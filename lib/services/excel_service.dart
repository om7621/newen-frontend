import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../templates/cps3000_template.dart';
import '../templates/dps_template.dart';
import '../templates/dps2500_template.dart';
import '../Database/db_helper.dart';
import 'dart:async';

class ExcelService {
  // Updated to the new Azure Backend URL
  static const String _backendUrl = "https://newen-traceability-backend-decsebgxgfdygfem.centralindia-01.azurewebsites.net";

  // Method for exporting a SINGLE panel report
  static Future<String> exportPanelReport(String panelSerial) async {
    if (kIsWeb) {
      final url = "$_backendUrl/export_excel?panel=$panelSerial";
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
    String productType = panelData?['product_type'] ?? "CPS3000";

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

    Map<String, Map<String, dynamic>> dbMap = {};
    for (var row in data) {
      dbMap[row["component"]] = row;
    }

    // Determine sections based on product type
    Map<String, List<String>> sections;
    if (productType == "DPS") {
      sections = DPSTemplate.sections;
    } else if (productType == "DPS 2500") {
      sections = DPS2500Template.sections;
    } else {
      sections = CPS3000Template.sections;
    }

    sections.forEach((section, components) {
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

    Directory? dir = await getExternalStorageDirectory();
    if (dir == null) throw Exception("Could not access storage");
    
    String newPath = "${dir.path.split("Android")[0]}Download";
    final file = File("$newPath/traceability_$panelSerial.xlsx");
    file
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    return file.path;
  }

  // Method for exporting the MASTER summary report
  static Future<String> exportFullSummaryReport(String productType) async {
    if (kIsWeb) {
      String route;
      if (productType == "DPS") {
        route = "export_dps_summary";
      } else if (productType == "DPS 2500") {
        route = "export_dps2500_summary";
      } else {
        route = "export_cps_summary";
      }
      final url = "$_backendUrl/$route";
      return "WEB_DOWNLOAD:$url";
    }

    var excel = Excel.createExcel();
    excel.rename('Sheet1', 'Master Summary');
    Sheet sheet = excel['Master Summary'];

    final db = await DBHelper.database;
    List<Map<String, dynamic>> panels = await db.query(
      "panels", 
      where: "product_type = ?", 
      whereArgs: [productType],
      orderBy: "panel_serial DESC"
    );

    List<String> headers = [
      "Panel Sr. No.",
      "Start Date",
      "End Date",
      "Project Name",
      "Product Type",
      "Work Order No.",
      "Prepared By",
      "Verified By",
      "Approved By",
      "Remarks"
    ];

    List<String> allComponents = [];
    
    // Determine sections based on product type
    Map<String, List<String>> sections;
    if (productType == "DPS") {
      sections = DPSTemplate.sections;
    } else if (productType == "DPS 2500") {
      sections = DPS2500Template.sections;
    } else {
      sections = CPS3000Template.sections;
    }
    
    sections.forEach((section, components) {
      allComponents.addAll(components);
    });

    headers.addAll(allComponents);
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

    for (var panel in panels) {
      String serial = panel['panel_serial'] ?? "";
      List<CellValue?> row = [
        TextCellValue(serial),
        TextCellValue(panel['start_date'] ?? ""),
        TextCellValue(panel['end_date'] ?? ""),
        TextCellValue(panel['project_name'] ?? ""),
        TextCellValue(panel['product_type'] ?? ""),
        TextCellValue(panel['reference_document'] ?? ""),
        TextCellValue(panel['prepared_by'] ?? ""),
        TextCellValue(panel['verified_by'] ?? ""),
        TextCellValue(panel['approved_by'] ?? ""),
        TextCellValue(panel['remarks'] ?? ""),
      ];

      List<Map<String, dynamic>> componentsData = await db.query(
        "components",
        where: "panel = ?",
        whereArgs: [serial],
      );

      Map<String, String> compMap = {};
      for (var c in componentsData) {
        compMap[c['component']] = c['serial'] ?? "";
      }

      for (var compName in allComponents) {
        row.add(TextCellValue(compMap[compName] ?? ""));
      }

      sheet.appendRow(row);
    }

    Directory? dir = await getExternalStorageDirectory();
    if (dir == null) throw Exception("Could not access storage");
    String newPath = "${dir.path.split("Android")[0]}Download";
    final file = File("$newPath/Master_Traceability_${productType}_Report.xlsx");
    file
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    return file.path;
  }
}
