import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../templates/cps3000_template.dart';
import '../Database/db_helper.dart';
import 'dart:async';

// We use an abstract class and conditional exports/logic to handle Web safely
class ExcelService {

  static Future<String> exportPanelReport(String panelSerial) async {
    if (kIsWeb) {
      // For Web, we redirect to the backend's export endpoint
      final url = "https://newen-tracibility.azurewebsites.net/export_excel?panel=$panelSerial";
      
      // Using a safer way to trigger download in Web without breaking Mobile
      return "WEB_DOWNLOAD:$url";
    }

    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Traceability');
    Sheet sheet = excel['Traceability'];

    final db = await DBHelper.database;

    List<Map<String, dynamic>> panelResult = await db.query(
      "panels",
      where: "panel_serial = ?",
      whereArgs: [panelSerial],
    );

    Map<String, dynamic>? panelData = panelResult.isNotEmpty ? panelResult.first : null;

    sheet.appendRow([TextCellValue("TRACEABILITY REPORT")]);
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue("Panel ID : $panelSerial")]);
    sheet.appendRow([]);
    sheet.appendRow([TextCellValue("Start Date"), TextCellValue(panelData?['start_date'] ?? "")]);
    sheet.appendRow([TextCellValue("End Date"), TextCellValue(panelData?['end_date'] ?? "")]);
    sheet.appendRow([TextCellValue("Project Name"), TextCellValue(panelData?['project_name'] ?? "")]);
    sheet.appendRow([TextCellValue("Panel Sr No"), TextCellValue(panelSerial)]);
    sheet.appendRow([TextCellValue("Prepared By"), TextCellValue(panelData?['prepared_by'] ?? "")]);
    sheet.appendRow([TextCellValue("Verified By"), TextCellValue(panelData?['verified_by'] ?? "")]);
    sheet.appendRow([TextCellValue("Approved By"), TextCellValue(panelData?['approved_by'] ?? "")]);
    sheet.appendRow([TextCellValue("Remarks"), TextCellValue(panelData?['remarks'] ?? "")]);
    sheet.appendRow([]);
    sheet.appendRow([
      TextCellValue("Section"),
      TextCellValue("Component"),
      TextCellValue("Make"),
      TextCellValue("Serial"),
      TextCellValue("Time")
    ]);

    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      await db.query("components", where: "panel = ?", whereArgs: [panelSerial]),
    );

    data.sort((a, b) => a["section"].compareTo(b["section"]));
    Map<String, Map<String, dynamic>> dbMap = {};
    for (var row in data) {
      dbMap[row["component"]] = row;
    }

    CPS3000Template.sections.forEach((section, components) {
      for (var component in components) {
        var dbRow = dbMap[component];
        sheet.appendRow([
          TextCellValue(section),
          TextCellValue(component),
          TextCellValue(dbRow?["make"] ?? ""),
          TextCellValue(dbRow?["serial"] ?? ""),
          TextCellValue(dbRow?["time"] != null ? dbRow!["time"].toString().split(".")[0] : "")
        ]);
      }
    });

    // Save logic for Mobile
    Directory? dir = await getExternalStorageDirectory();
    String newPath = dir!.path.split("Android")[0] + "Download";
    final file = File("$newPath/traceability_$panelSerial.xlsx");
    file
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    return file.path;
  }
}
