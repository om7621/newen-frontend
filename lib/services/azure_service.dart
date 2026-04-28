import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../Database/db_helper.dart';

class AzureService {
  // Updated to the new Azure Backend URL
  static const String baseUrl = "https://newen-traceability-backend-decsebgxgfdygfem.centralindia-01.azurewebsites.net";

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  /// Smart Auto-Sync for Mobile
  static Future<void> performIncrementalSync() async {
    if (kIsWeb) return; 
    try {
      final unsyncedPanels = await DBHelper.getUnsyncedPanels();
      final unsyncedComponents = await DBHelper.getUnsyncedComponents();
      if (unsyncedPanels.isEmpty && unsyncedComponents.isEmpty) return;

      Set<String> panelsToSync = {};
      for (var p in unsyncedPanels) {
        if (p['panel_serial'] != null) panelsToSync.add(p['panel_serial']);
      }
      for (var c in unsyncedComponents) {
        if (c['panel'] != null) panelsToSync.add(c['panel']);
      }

      for (var serial in panelsToSync) {
        await syncFullPanel(serial);
      }
    } catch (e) {
      print("Background Sync Error: $e");
    }
  }

  /// Syncs everything for a panel. Optimized for immediate UI feedback.
  static Future<void> syncFullPanel(String panelSerial, {Map<String, dynamic>? panelData, List<Map<String, dynamic>>? components}) async {
    try {
      Map<String, dynamic> finalPanel;
      List<Map<String, dynamic>> finalComponents;

      if (kIsWeb && panelData != null && components != null) {
        finalPanel = panelData;
        finalComponents = components;
      } else {
        final db = await DBHelper.database;
        final panelList = await db.query("panels", where: "panel_serial = ?", whereArgs: [panelSerial]);
        if (panelList.isEmpty) return;
        finalPanel = Map<String, dynamic>.from(panelList.first);

        final compList = await db.query("components", where: "panel = ?", whereArgs: [panelSerial]);
        finalComponents = compList.map((c) => {
          "section_name": c["section"],
          "component_name": c["component"],
          "make": c["make"],
          "serial_number": c["serial"]
        }).toList();
      }

      if (!finalPanel.containsKey('status')) finalPanel['status'] = "IN_PROGRESS";

      final response = await http.post(
        Uri.parse("$baseUrl/sync_full_panel"),
        headers: _headers,
        body: jsonEncode({
          "panel": finalPanel,
          "components": finalComponents,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        if (!kIsWeb) {
          await DBHelper.markPanelSynced(panelSerial);
          final db = await DBHelper.database;
          await db.update("components", {"is_synced": 1}, where: "panel = ?", whereArgs: [panelSerial]);
        }
      }
    } catch (e) {
      print("Sync Error for $panelSerial: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchPanels() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_panels"), headers: _headers);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchSectionData(String panelSerial, String sectionName) async {
    try {
      // Improved URL encoding for Web compatibility
      final uri = Uri.parse("$baseUrl/get_section_data").replace(queryParameters: {
        'panel': panelSerial,
        'section': sectionName,
      });
      
      final response = await http.get(uri, headers: _headers);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
