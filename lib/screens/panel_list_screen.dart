import 'package:flutter/material.dart';
import '../services/azure_service.dart';
import 'section_dashboard.dart';

class PanelListScreen extends StatefulWidget {
  const PanelListScreen({super.key});

  @override
  State<PanelListScreen> createState() => _PanelListScreenState();
}

class _PanelListScreenState extends State<PanelListScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _panels = [];

  @override
  void initState() {
    super.initState();
    _fetchPanels();
  }

  Future<void> _fetchPanels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final panels = await AzureService.fetchPanels();
      
      // Sort panels date-wise: Newest created last appears at top
      // We assume panel_serial or start_date contains timing info, or we rely on the order from Azure.
      // If the backend returns them in descending order, we are already good.
      
      setState(() {
        _panels = panels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cloud Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Continue Existing Panel"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPanels,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _panels.isEmpty
              ? const Center(
                  child: Text("No panels found in Azure database"),
                )
              : ListView.builder(
                  itemCount: _panels.length,
                  itemBuilder: (context, index) {
                    final panelData = _panels[index];
                    final String serial = panelData["panel_serial"] ?? "Unknown";
                    final String productType = panelData["product_type"] ?? "CPS3000";

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(
                          serial,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "$productType | Project: ${panelData["project_name"] ?? ""}",
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SectionDashboard(
                                panelSerial: serial,
                                productType: productType,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
