import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../Database/db_helper.dart';

class AzureService {
  static const String baseUrl = "https://newen-tracibility.azurewebsites.net";

  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  /// Smart Auto-Sync for Mobile
  static Future<void> performIncrementalSync() async {
    if (kIsWeb) return; // Web uses direct sync on save
    try {
      final unsyncedPanels = await DBHelper.getUnsyncedPanels();
      final unsyncedComponents = await DBHelper.getUnsyncedComponents();
      if (unsyncedPanels.isEmpty && unsyncedComponents.isEmpty) return;

      Set<String> panelsToSync = {};
      for (var p in unsyncedPanels) panelsToSync.add(p['panel_serial']);
      for (var c in unsyncedComponents) panelsToSync.add(c['panel']);

      for (var serial in panelsToSync) {
        await syncFullPanel(serial);
      }
    } catch (e) {
      print("Background Sync Error: $e");
    }
  }

  /// Pushes everything for a panel to Azure.
  /// Works for both Mobile (local DB) and Web (direct data).
  static Future<void> syncFullPanel(String panelSerial, {Map<String, dynamic>? panelData, List<Map<String, dynamic>>? components}) async {
    try {
      Map<String, dynamic> finalPanel;
      List<Map<String, dynamic>> finalComponents;

      if (kIsWeb && panelData != null && components != null) {
        // Direct sync for Web
        finalPanel = panelData;
        finalComponents = components;
      } else {
        // Fetch from Local DB (Mobile)
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

      final response = await http.post(
        Uri.parse("$baseUrl/sync_full_panel"),
        headers: _headers,
        body: jsonEncode({
          "panel": finalPanel,
          "components": finalComponents,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200 && !kIsWeb) {
        await DBHelper.markPanelSynced(panelSerial);
        // Mark all local components as synced
        final db = await DBHelper.database;
        await db.update("components", {"is_synced": 1}, where: "panel = ?", whereArgs: [panelSerial]);
      }
    } catch (e) {
      print("Sync Error: $e");
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
      // Encode URL parameters correctly for Web Browsers
      final queryParams = {
        'panel': panelSerial,
        'section': sectionName,
      };
      final uri = Uri.parse("$baseUrl/get_section_data").replace(queryParameters: queryParams);
      
      final response = await http.get(uri, headers: _headers);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(jsonDecode(response.body));
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  // Helper for direct sync if needed (Legacy Support)
  static Future<void> syncSection(String panelSerial, String sectionName, List<Map<String, dynamic>> data) async {
    await syncFullPanel(panelSerial);
  }
}
