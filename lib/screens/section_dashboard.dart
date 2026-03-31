import 'package:flutter/material.dart';
import 'component_entry_screen.dart';
import 'panel_qr_screen.dart';
import '../services/excel_service.dart';
import '../templates/cps3000_template.dart';
import '../templates/dps_template.dart';

class SectionDashboard extends StatelessWidget {
  final String panelSerial;
  final String productType;

  SectionDashboard({
    super.key,
    required this.panelSerial,
    this.productType = "CPS3000",
  });

  @override
  Widget build(BuildContext context) {
    // Determine sections based on product type
    final List<String> sections = (productType == "DPS")
        ? DPSTemplate.sections.keys.toList()
        : CPS3000Template.sections.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Panel: $panelSerial", style: const TextStyle(fontSize: 18)),
            Text("Model: $productType", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(sections[index]),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComponentEntryScreen(
                            sectionName: sections[index],
                            panelSerial: panelSerial,
                            productType: productType, // Pass product type
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code),
                    label: const Text("GENERATE PANEL QR"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PanelQRScreen(
                            panelSerial: panelSerial,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.file_download),
                    label: const Text("EXPORT EXCEL REPORT"),
                    onPressed: () async {
                      String path = await ExcelService.exportPanelReport(panelSerial);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(path.startsWith("WEB_DOWNLOAD") 
                              ? "Download started..." 
                              : "Excel saved at: $path"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
