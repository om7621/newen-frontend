import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'component_entry_screen.dart';
import 'panel_qr_screen.dart';
import '../services/excel_service.dart';
import '../templates/cps3000_template.dart';
import '../templates/dps_template.dart';
import '../templates/dps2500_template.dart';
// Use dynamic import to prevent mobile build errors
import 'dart:js' as js;

class SectionDashboard extends StatelessWidget {
  final String panelSerial;
  final String productType;

  SectionDashboard({
    super.key,
    required this.panelSerial,
    this.productType = "CPS 3000", // Updated from CPS3000
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundGreen = Colors.green.shade50;

    // Updated Logic: Handle CPS 3000, CPS 2500, and DPS
    List<String> sections;
    if (productType == "CPS 2500") {
      sections = DPS2500Template.sections.keys.toList();
    } else if (productType == "DPS") {
      sections = DPSTemplate.sections.keys.toList();
    } else {
      sections = CPS3000Template.sections.keys.toList();
    }

    return Scaffold(
      backgroundColor: backgroundGreen,
      appBar: AppBar(
        backgroundColor: backgroundGreen,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Panel: $panelSerial", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Model: $productType", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                    border: Border.all(color: Colors.green.shade100, width: 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    title: Text(sections[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComponentEntryScreen(
                            sectionName: sections[index],
                            panelSerial: panelSerial,
                            productType: productType,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
              ],
            ),
            child: Column(
              children: [
                _buildActionButton(
                  label: "GENERATE PANEL QR",
                  icon: Icons.qr_code_rounded,
                  color: Colors.blueGrey.shade700,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PanelQRScreen(panelSerial: panelSerial),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  label: "EXPORT EXCEL REPORT",
                  icon: Icons.file_download_outlined,
                  color: const Color(0xFF1B5E20),
                  onTap: () async {
                    String result = await ExcelService.exportPanelReport(panelSerial);

                    if (kIsWeb && result.startsWith("WEB_DOWNLOAD:")) {
                      final url = result.split("WEB_DOWNLOAD:")[1];
                      // Use dart:js to open URL on web safely
                      js.context.callMethod('open', [url, '_blank']);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Excel saved at: $result")),
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
      ),
    );
  }
}
