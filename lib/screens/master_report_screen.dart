import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/excel_service.dart';
import 'dart:html' as html if (dart.library.io) 'dart:io';

class MasterReportScreen extends StatefulWidget {
  const MasterReportScreen({super.key});

  @override
  State<MasterReportScreen> createState() => _MasterReportScreenState();
}

class _MasterReportScreenState extends State<MasterReportScreen> {
  bool isLoading = false;

  Future<void> _downloadMasterReport(String productType) async {
    setState(() => isLoading = true);
    try {
      String result = await ExcelService.exportFullSummaryReport(productType);
      
      if (kIsWeb && result.startsWith("WEB_DOWNLOAD:")) {
        final url = result.split("WEB_DOWNLOAD:")[1];
        (html.window as dynamic).open(url, "_blank");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$productType Master Report saved at: $result")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Export failed: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Master Traceability Report"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.table_view, size: 100, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                "Generate Master Excel Sheet",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Select the panel model to download the complete traceability summary in one row per panel.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              if (isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    _buildDownloadButton("CPS3000"),
                    const SizedBox(height: 20),
                    _buildDownloadButton("DPS"),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(String type) {
    return SizedBox(
      width: 300,
      height: 60,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.download),
        label: Text("DOWNLOAD $type MASTER EXCEL"),
        style: ElevatedButton.styleFrom(
          backgroundColor: type == "CPS3000" ? Colors.green.shade700 : Colors.blue.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => _downloadMasterReport(type),
      ),
    );
  }
}
