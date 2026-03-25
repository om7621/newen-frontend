import 'package:flutter/material.dart';
import '../templates/cps3000_template.dart';
import '../templates/component_make_template.dart';
import 'barcode_scanner_screen.dart';
import '../Database/db_helper.dart';
import '../services/azure_service.dart';

class ComponentEntryScreen extends StatefulWidget {
  final String sectionName;
  final String panelSerial;

  const ComponentEntryScreen({
    super.key,
    required this.sectionName,
    required this.panelSerial,
  });

  @override
  State<ComponentEntryScreen> createState() => _ComponentEntryScreenState();
}

class _ComponentEntryScreenState extends State<ComponentEntryScreen> {
  List<String> components = [];
  Map<String, String> serialValues = {};
  Map<String, String> makeValues = {};
  Set<String> savedComponents = {};
  bool isSyncing = false;
  
  Map<String, TextEditingController> controllers = {};
  Map<String, FocusNode> focusNodes = {};

  @override
  void initState() {
    super.initState();
    components = CPS3000Template.sections[widget.sectionName] ?? [];
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

    try {
      final cloudData = await AzureService.fetchSectionData(widget.panelSerial, widget.sectionName);
      if (cloudData.isNotEmpty) {
        setState(() {
          cloudData.forEach((compName, details) {
            serialValues[compName] = details["serial"];
            makeValues[compName] = details["make"];
            if (controllers.containsKey(compName)) {
              controllers[compName]?.text = details["serial"] ?? "";
            }
            savedComponents.add(compName);
          });
        });
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }

  Future<void> _saveLocal(String component) async {
    if (serialValues[component] == null || serialValues[component]!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter serial number first")));
      return;
    }
    
    await DBHelper.insertComponent(
      widget.panelSerial, 
      widget.sectionName, 
      component, 
      serialValues[component] ?? "", 
      makeValues[component] ?? ""
    );
    
    setState(() => savedComponents.add(component));
    
    int currentIndex = components.indexOf(component);
    if (currentIndex < components.length - 1) {
      focusNodes[components[currentIndex + 1]]?.requestFocus();
    } else {
      FocusScope.of(context).unfocus();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$component Saved Local"), duration: const Duration(milliseconds: 500)),
    );
  }

  Future<void> syncSectionToCloud() async {
    setState(() => isSyncing = true);
    try {
      List<Map<String, dynamic>> sectionUploadData = [];
      for (var comp in components) {
        if (serialValues[comp] != null && serialValues[comp]!.isNotEmpty) {
          sectionUploadData.add({
            "component": comp,
            "serial": serialValues[comp],
            "make": makeValues[comp] ?? "",
          });
        }
      }

      if (sectionUploadData.isNotEmpty) {
        await AzureService.syncSection(widget.panelSerial, widget.sectionName, sectionUploadData);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Section synced to Azure")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sync failed: Check if server is running on Azure")));
    } finally {
      setState(() => isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.sectionName}"),
        actions: [
          if (isSyncing)
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
            )
          else
            IconButton(
              icon: const Icon(Icons.cloud_upload),
              onPressed: syncSectionToCloud,
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
                          onSubmitted: (value) => _saveLocal(component), 
                          onChanged: (v) {
                            serialValues[component] = v;
                            if (savedComponents.contains(component)) {
                              setState(() => savedComponents.remove(component));
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
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
                                label: const Text("CAMERA SCAN"),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.save),
                                onPressed: () => _saveLocal(component),
                                label: const Text("SAVE LOCAL"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700, 
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                            ],
                          ),
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