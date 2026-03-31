import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../templates/cps3000_template.dart';
import '../templates/dps_template.dart';
import '../templates/component_make_template.dart';
import 'barcode_scanner_screen.dart';
import '../Database/db_helper.dart';
import '../services/azure_service.dart';

class ComponentEntryScreen extends StatefulWidget {
  final String sectionName;
  final String panelSerial;
  final String productType;

  const ComponentEntryScreen({
    super.key,
    required this.sectionName,
    required this.panelSerial,
    this.productType = "CPS3000",
  });

  @override
  State<ComponentEntryScreen> createState() => _ComponentEntryScreenState();
}

class _ComponentEntryScreenState extends State<ComponentEntryScreen> {
  List<String> components = [];
  Map<String, String> serialValues = {};
  Map<String, String> makeValues = {};
  Set<String> savedComponents = {};
  bool isLoading = false;
  
  Map<String, TextEditingController> controllers = {};
  Map<String, FocusNode> focusNodes = {};

  @override
  void initState() {
    super.initState();
    // Load components based on product type
    if (widget.productType == "DPS") {
      components = DPSTemplate.sections[widget.sectionName] ?? [];
    } else {
      components = CPS3000Template.sections[widget.sectionName] ?? [];
    }

    for (var comp in components) {
      controllers[comp] = TextEditingController();
      focusNodes[comp] = FocusNode();
    }
    loadData();
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    focusNodes.forEach((key, node) => node.dispose());
    super.dispose();
  }

  void loadData() async {
    setState(() => isLoading = true);
    
    if (!kIsWeb) {
      final data = await DBHelper.getSectionComponents(
        widget.panelSerial,
        widget.sectionName,
      );

      setState(() {
        for (var row in data) {
          String comp = row["component"];
          serialValues[comp] = row["serial"];
          makeValues[comp] = row["make"];
          controllers[comp]?.text = row["serial"] ?? "";
          if (row["serial"] != null && row["serial"].toString().isNotEmpty) {
            savedComponents.add(comp);
          }
        }
      });
    }

    try {
      final cloudData = await AzureService.fetchSectionData(widget.panelSerial, widget.sectionName);
      if (cloudData.isNotEmpty) {
        setState(() {
          cloudData.forEach((compName, details) {
            String cloudSerial = details["serial_number"] ?? "";
            String cloudMake = details["make"] ?? "";
            
            if (cloudSerial.isNotEmpty) {
              serialValues[compName] = cloudSerial;
              makeValues[compName] = cloudMake;
              if (controllers.containsKey(compName)) {
                controllers[compName]?.text = cloudSerial;
              }
              savedComponents.add(compName);
            }
          });
        });
      }
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleSave(String component) async {
    if (serialValues[component] == null || serialValues[component]!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter serial number first")));
      return;
    }

    if (kIsWeb) {
      await _syncAllToCloud();
    } else {
      await DBHelper.insertComponent(
        widget.panelSerial, 
        widget.sectionName, 
        component, 
        serialValues[component] ?? "", 
        makeValues[component] ?? ""
      );
      setState(() => savedComponents.add(component));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$component Saved Locally"), duration: const Duration(milliseconds: 500)),
      );
    }
    
    int currentIndex = components.indexOf(component);
    if (currentIndex < components.length - 1) {
      focusNodes[components[currentIndex + 1]]?.requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _syncAllToCloud() async {
    setState(() => isLoading = true);
    try {
      List<Map<String, dynamic>> allComponentsToUpload = [];
      for (var comp in components) {
        if (serialValues[comp] != null && serialValues[comp]!.isNotEmpty) {
          allComponentsToUpload.add({
            "section_name": widget.sectionName,
            "component_name": comp,
            "make": makeValues[comp] ?? "",
            "serial_number": serialValues[comp],
          });
        }
      }

      if (kIsWeb) {
        await AzureService.syncFullPanel(
          widget.panelSerial,
          panelData: {"panel_serial": widget.panelSerial, "product_type": widget.productType},
          components: allComponentsToUpload,
        );
      } else {
        await AzureService.syncFullPanel(widget.panelSerial);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data Synced to Cloud")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sync failed: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.sectionName} (${widget.productType})"),
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            IconButton(
              icon: const Icon(Icons.cloud_upload),
              onPressed: _syncAllToCloud,
            )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: components.length,
              itemBuilder: (context, index) {
                String component = components[index];
                bool isSaved = savedComponents.contains(component);
                List<String> makeList = ComponentMakeTemplate.makeOptions[component] ?? ["UNKNOWN"];

                if (makeList.length == 1) makeValues[component] = makeList[0];

                return Card(
                  color: isSaved ? Colors.green.shade50 : Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: isSaved ? Colors.green.shade200 : Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(component, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                            if (isSaved) const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (makeList.length > 1)
                          DropdownButtonFormField<String>(
                            value: makeList.contains(makeValues[component]) ? makeValues[component] : null,
                            isExpanded: true,
                            decoration: const InputDecoration(labelText: "Select Make", border: OutlineInputBorder()),
                            items: makeList.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                            onChanged: (v) => setState(() {
                              makeValues[component] = v!;
                              savedComponents.remove(component);
                            }),
                          )
                        else
                          Text("Make: ${makeList[0]}", style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: controllers[component],
                          focusNode: focusNodes[component],
                          decoration: const InputDecoration(labelText: "Serial Number", border: OutlineInputBorder()),
                          onSubmitted: (value) => _handleSave(component), 
                          onChanged: (v) {
                            serialValues[component] = v;
                            if (savedComponents.contains(component)) {
                              setState(() => savedComponents.remove(component));
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (!kIsWeb)
                              ElevatedButton.icon(
                                icon: const Icon(Icons.qr_code_scanner),
                                onPressed: () async {
                                  final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()));
                                  if (res != null) {
                                    setState(() {
                                      serialValues[component] = res;
                                      controllers[component]?.text = res;
                                      savedComponents.remove(component);
                                    });
                                  }
                                },
                                label: const Text("SCAN"),
                              ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: Icon(kIsWeb ? Icons.cloud_upload : Icons.save),
                              onPressed: () => _handleSave(component),
                              label: Text(kIsWeb ? "SYNC TO CLOUD" : "SAVE LOCAL"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700, 
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}