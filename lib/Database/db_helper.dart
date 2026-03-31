import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DBHelper {
  static Database? _database;
  static Future<Database>? _initFuture;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    
    // Ensure initialization only happens once
    _initFuture ??= _initDB();
    _database = await _initFuture;
    return _database!;
  }

  static Future<Database> _initDB() async {
    if (kIsWeb) {
      try {
        var factory = databaseFactoryFfiWeb;
        return await factory.openDatabase('traceability.db',
            options: OpenDatabaseOptions(
              version: 2,
              onCreate: _createDB,
              onUpgrade: _onUpgrade,
            ));
      } catch (e) {
        // Fallback for some web environments
        print("Web DB Init error: $e");
        rethrow;
      }
    } else {
      String path = join(await getDatabasesPath(), 'traceability.db');
      return await openDatabase(
        path,
        version: 2,
        onCreate: _createDB,
        onUpgrade: _onUpgrade,
      );
    }
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE components ADD COLUMN is_synced INTEGER DEFAULT 0");
      await db.execute("ALTER TABLE panels ADD COLUMN is_synced INTEGER DEFAULT 0");
    }
  }

  static Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE panels(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        panel_serial TEXT UNIQUE,
        product_type TEXT,
        prepared_by TEXT,
        start_date TEXT,
        end_date TEXT,
        project_name TEXT,
        reference_document TEXT,
        verified_by TEXT,
        approved_by TEXT,
        remarks TEXT,
        status TEXT,
        is_synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE components(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        panel TEXT,
        section TEXT,
        component TEXT,
        make TEXT,
        serial TEXT,
        time TEXT,
        is_synced INTEGER DEFAULT 0,
        UNIQUE(panel, component) ON CONFLICT REPLACE
      )
    ''');
  }

  static Future<void> insertPanel(
      String panelSerial, String productType, String preparedBy, String startDate,
      String projectName, String referenceDoc, String verifiedBy, String approvedBy, String remarks,
      ) async {
    final db = await database;
    await db.insert(
      "panels",
      {
        "panel_serial": panelSerial,
        "product_type": productType,
        "prepared_by": preparedBy,
        "start_date": startDate,
        "end_date": "",
        "project_name": projectName,
        "reference_document": referenceDoc,
        "verified_by": verifiedBy,
        "approved_by": approvedBy,
        "remarks": remarks,
        "status": "IN_PROGRESS",
        "is_synced": 0 
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getUnsyncedPanels() async {
    final db = await database;
    return await db.query("panels", where: "is_synced = 0");
  }

  static Future<List<Map<String, dynamic>>> getUnsyncedComponents() async {
    final db = await database;
    return await db.query("components", where: "is_synced = 0");
  }

  static Future<void> markPanelSynced(String panelSerial) async {
    final db = await database;
    await db.update("panels", {"is_synced": 1}, where: "panel_serial = ?", whereArgs: [panelSerial]);
  }

  static Future<void> markComponentSynced(int id) async {
    final db = await database;
    await db.update("components", {"is_synced": 1}, where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getPanels() async {
    final db = await database;
    return await db.query("panels");
  }

  static Future<void> insertComponent(String panel, String section, String component, String serial, String make) async {
    final db = await database;
    await db.insert(
      "components",
      {
        "panel": panel,
        "section": section,
        "component": component,
        "make": make,
        "serial": serial,
        "time": DateTime.now().toString(),
        "is_synced": 0 
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getSectionComponents(String panel, String section) async {
    final db = await database;
    return await db.query("components", where: "panel = ? AND section = ?", whereArgs: [panel, section]);
  }
}
