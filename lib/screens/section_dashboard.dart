import 'package:flutter/material.dart';
import 'component_entry_screen.dart';
import 'panel_qr_screen.dart';
import '../services/excel_service.dart';

class SectionDashboard extends StatelessWidget {

  final String panelSerial;

  SectionDashboard({super.key, required this.panelSerial});

  final List<String> sections = [
    "Enclosure",
    "Fan Box",
    "Magnetics",
    "Switchgears",
    "Sensors",
    "Resistors",
    "PCB",
    "Capacitor",
    "Power Supply",
    "U1 STACK",
    "V1 STACK",
    "W1 STACK",
    "U2 STACK",
    "V2 STACK",
    "W2 STACK"
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Panel: $panelSerial"),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, index){

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: ListTile(
                    title: Text(sections[index]),
                    trailing: const Icon(Icons.arrow_forward),

                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ComponentEntryScreen(
                            sectionName: sections[index],
                            panelSerial: panelSerial,
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

                ElevatedButton(
                  child: const Text("GENERATE PANEL QR"),
                  onPressed: (){
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

                const SizedBox(height: 10),

                ElevatedButton(
                  child: const Text("EXPORT EXCEL REPORT"),
                  onPressed: () async {

                    String path =
                    await ExcelService.exportPanelReport(panelSerial);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Excel saved at: $path"),
                      ),
                    );

                  },
                ),

              ],
            ),
          )

        ],
      ),
    );
  }
}