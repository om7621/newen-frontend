import 'package:cloud_firestore/cloud_firestore.dart';
import '../Database/db_helper.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> syncPanelToCloud(String panelSerial) async {
    try {
      // 1. Get Panel Data from SQLite
      final db = await DBHelper.database;
      List<Map<String, dynamic>> panelData = await db.query(
        "panels",
        where: "panel_serial = ?",
        whereArgs: [panelSerial],
      );

      if (panelData.isEmpty) return;

      // 2. Get Components Data from SQLite
      List<Map<String, dynamic>> componentsData = await db.query(
        "components",
        where: "panel = ?",
        whereArgs: [panelSerial],
      );

      // 3. Upload to Firestore
      // Setting a timeout to prevent infinite loading if DB is not initialized
      await _firestore.collection("panels").doc(panelSerial).set(panelData.first)
          .timeout(const Duration(seconds: 15));

      if (componentsData.isNotEmpty) {
        WriteBatch batch = _firestore.batch();
        for (var comp in componentsData) {
          DocumentReference docRef = _firestore
              .collection("panels")
              .doc(panelSerial)
              .collection("components")
              .doc("${comp['section']}_${comp['component']}");
          batch.set(docRef, comp);
        }
        await batch.commit().timeout(const Duration(seconds: 15));
      }

    } catch (e) {
      print("Error syncing to Firebase: $e");
      rethrow;
    }
  }

  static Future<void> syncAllPanels() async {
    final panels = await DBHelper.getPanels();
    if (panels.isEmpty) {
      throw Exception("No data found to sync.");
    }
    for (var panel in panels) {
      await syncPanelToCloud(panel['panel_serial']);
    }
  }
}