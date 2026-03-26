import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Database/db_helper.dart';

class AzureService {
  static const String baseUrl = "https://newen-tracibility.azurewebsites.net";

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  /// Smart Auto-Sync: Only syncs what has changed (is_synced = 0)
  static Future<void> performIncrementalSync() async {
    try {
      final unsyncedPanels = await DBHelper.getUnsyncedPanels();
      for (var panel in unsyncedPanels) {
        final response = await http.post(
          Uri.parse("$baseUrl/sync_full_panel"),
          headers: _headers,
          body: jsonEncode({"panel": panel, "components": []}),
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          await DBHelper.markPanelSynced(panel['panel_serial']);
        }
      }

      final unsyncedComponents = await DBHelper.getUnsyncedComponents();
      if (unsyncedComponents.isEmpty) return;

      Map<String, Map<String, List<Map<String, dynamic>>>> grouped = {};
      for (var comp in unsyncedComponents) {
        String p = comp['panel'];
        String s = comp['section'];
        grouped.putIfAbsent(p, () => {});
        grouped[p]!.putIfAbsent(s, () => []);
        grouped[p]![s]!.add(comp);
      }

      for (var panelSerial in grouped.keys) {
        for (var sectionName in grouped[panelSerial]!.keys) {
          final data = grouped[panelSerial]![sectionName]!;
          final response = await http.post(
            Uri.parse("$baseUrl/sync_section"),
            headers: _headers,
            body: jsonEncode({
              "panel_serial": panelSerial,
              "section_name": sectionName,
              "data": data,
            }),
          );

          if (response.statusCode == 200) {
            for (var comp in data) {
              await DBHelper.markComponentSynced(comp['id']);
            }
          }
        }
      }
    } catch (e) {
      print("Background Sync Error: $e");
    }
  }

  static Future<void> syncFullPanel(String panelSerial) async {
    try {
      final db = await DBHelper.database;
      final panelData = await db.query("panels", where: "panel_serial = ?", whereArgs: [panelSerial]);
      if (panelData.isEmpty) return;

      final response = await http.post(
        Uri.parse("$baseUrl/sync_full_panel"),
        headers: _headers,
        body: jsonEncode({"panel": panelData.first, "components": []}),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        await DBHelper.markPanelSynced(panelSerial);
      } else {
        throw Exception("Server Error: ${response.body}");
      }
    } catch (e) {
      print("Sync full panel error: $e");
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchPanels() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/get_panels"),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      print("Fetch Error: $e");
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchSectionData(String panelSerial, String sectionName) async {
    try {
      // CRITICAL FIX: Encode query parameters for Web compatibility
      final queryParams = {
        'panel': panelSerial,
        'section': sectionName,
      };
      final uri = Uri.parse("$baseUrl/get_section_data").replace(queryParameters: queryParams);
      
      print("Fetching Cloud Data for $sectionName...");
      final response = await http.get(uri, headers: _headers);
      
      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(jsonDecode(response.body));
        print("Found ${data.length} cloud entries for $sectionName");
        return data;
      }
      return {};
    } catch (e) {
      print("Fetch Section Data Error: $e");
      return {};
    }
  }

  static Future<void> syncSection(String panelSerial, String sectionName, List<Map<String, dynamic>> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/sync_section"),
        headers: _headers,
        body: jsonEncode({"panel_serial": panelSerial, "section_name": sectionName, "data": data}),
      );
      if (response.statusCode != 200) throw Exception("Sync failed");
    } catch (e) {
      rethrow;
    }
  }
}
