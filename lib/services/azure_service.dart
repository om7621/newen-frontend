import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Database/db_helper.dart';

class AzureService {
  static const String baseUrl = "https://newen-tracibility.azurewebsites.net";

  // Standard headers for Web compatibility
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
      final response = await http.get(
        Uri.parse("$baseUrl/get_section_data?panel=$panelSerial&section=$sectionName"),
        headers: _headers,
      );
      if (response.statusCode == 200) return Map<String, dynamic>.from(jsonDecode(response.body));
      return {};
    } catch (e) {
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
