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
  bool _isSearching = false;
  bool _isLoadingMore = false;
  List<Map<String, dynamic>> _allPanels = [];
  List<Map<String, dynamic>> _displayedPanels = [];
  
  final TextEditingController _searchController = TextEditingController();
  final Color backgroundGreen = Colors.green.shade50;
  
  int _pageSize = 20;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchPanels();
  }

  Future<void> _fetchPanels() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
    });

    try {
      final panels = await AzureService.fetchPanels();
      setState(() {
        _allPanels = panels;
        _applyFilterAndPagination();
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

  void _applyFilterAndPagination() {
    String query = _searchController.text.toLowerCase();
    
    // 1. Filter by search query
    List<Map<String, dynamic>> filtered = _allPanels.where((p) {
      String serial = (p["panel_serial"] ?? "").toString().toLowerCase();
      return serial.contains(query);
    }).toList();

    // 2. Paginate: Show only up to current page * size
    int limit = _currentPage * _pageSize;
    setState(() {
      _displayedPanels = filtered.take(limit).toList();
    });
  }

  void _loadMore() {
    setState(() {
      _isLoadingMore = true;
    });
    
    // Simulate a small delay for "Load More" feel
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentPage++;
        _applyFilterAndPagination();
        _isLoadingMore = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGreen,
      appBar: AppBar(
        title: _isSearching 
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Search Serial No...",
                border: InputBorder.none,
              ),
              onChanged: (v) => _applyFilterAndPagination(),
            )
          : const Text("Continue Existing Panel", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: !_isSearching,
        backgroundColor: backgroundGreen,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _applyFilterAndPagination();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchPanels,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _displayedPanels.isEmpty
              ? const Center(
                  child: Text("No matching panels found"),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _displayedPanels.length + 1, // +1 for the Load More button
                  itemBuilder: (context, index) {
                    if (index == _displayedPanels.length) {
                      // Check if there is more data to load
                      bool hasMore = _displayedPanels.length < _allPanels.length;
                      if (!hasMore || _searchController.text.isNotEmpty) return const SizedBox(height: 40);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: _isLoadingMore 
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.green.shade700,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _loadMore,
                              child: const Text("LOAD MORE PANELS"),
                            ),
                      );
                    }

                    final panelData = _displayedPanels[index];
                    final String serial = panelData["panel_serial"] ?? "Unknown";
                    final String productType = panelData["product_type"] ?? "CPS3000";
                    final bool isDPS = productType == "DPS";

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.green.shade100, width: 1),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDPS ? Colors.blue.shade50 : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDPS ? Colors.blue.shade100 : Colors.green.shade100,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            isDPS ? "DPS" : "CPS",
                            style: TextStyle(
                              color: isDPS ? Colors.blue.shade700 : Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        title: Text(
                          serial,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "Project: ${panelData["project_name"] ?? "N/A"}",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
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
