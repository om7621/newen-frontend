import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../Database/db_helper.dart';
import 'section_dashboard.dart';
import '../services/azure_service.dart';

class CreatePanelScreen extends StatefulWidget {
  const CreatePanelScreen({Key? key}) : super(key: key);

  @override
  State<CreatePanelScreen> createState() => _CreatePanelScreenState();
}

class _CreatePanelScreenState extends State<CreatePanelScreen> {
  final TextEditingController workOrderController = TextEditingController();
  final TextEditingController panelSerialController = TextEditingController();
  final TextEditingController referenceDocController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  // Updated to CPS 3000
  String productType = "CPS 3000";
  String? preparedBy;
  String? projectName;
  String? verifiedBy;
  DateTime? startDate;
  bool isCreating = false;

  List<String> workersList = ["Operator 1", "Operator 2", "Operator 3"];
  List<String> projectList = ["L&T", "RE+", "ONGC", "Amazon", "Toyota"];
  List<String> verifierList = ["Supervisor 1", "Supervisor 2", "Supervisor 3"];

  // Updated list: Removed "DPS" as requested
  final List<String> availableProductTypes = [
    "CPS 3000",
    "CPS 2500",
    "CPS 1250",
    "DPS 1500",
    "DPS 1000",
    "DPS 500",
  ];

  final Color primaryGreen = const Color(0xFF1B5E20);
  final Color backgroundGreen = Colors.green.shade50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGreen,
      appBar: AppBar(
        title: const Text("New Assembly Setup", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: backgroundGreen,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Basic Information"),
                _buildFormCard([
                  _buildTextField(
                    controller: workOrderController,
                    label: "Work Order No.",
                    icon: Icons.assignment_outlined,
                  ),
                  const Divider(height: 1, indent: 50),
                  _buildTextField(
                    controller: panelSerialController,
                    label: "Panel Serial Number",
                    icon: Icons.qr_code_rounded,
                  ),
                  const Divider(height: 1, indent: 50),
                  _buildProductTypeDropdown(),
                ]),
                const SizedBox(height: 24),
                _buildSectionTitle("Project Details"),
                _buildFormCard([
                  _buildDropdownWithAdd(
                    label: "Project Name",
                    value: projectName,
                    items: projectList,
                    onChanged: (v) => setState(() => projectName = v),
                    onAdd: addProjectDialog,
                    icon: Icons.business_outlined,
                  ),
                  const Divider(height: 1, indent: 50),
                  _buildTextField(
                    controller: referenceDocController,
                    label: "Reference Document",
                    icon: Icons.description_outlined,
                  ),
                  const Divider(height: 1, indent: 50),
                  _buildDatePicker(),
                ]),
                const SizedBox(height: 24),
                _buildSectionTitle("Personnel"),
                _buildFormCard([
                  _buildDropdownWithAdd(
                    label: "Prepared By",
                    value: preparedBy,
                    items: workersList,
                    onChanged: (v) => setState(() => preparedBy = v),
                    onAdd: addWorkerDialog,
                    icon: Icons.person_outline_rounded,
                  ),
                  const Divider(height: 1, indent: 50),
                  _buildDropdownWithAdd(
                    label: "Verified By",
                    value: verifiedBy,
                    items: verifierList,
                    onChanged: (v) => setState(() => verifiedBy = v),
                    onAdd: addVerifierDialog,
                    icon: Icons.verified_user_outlined,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildSectionTitle("Other"),
                _buildFormCard([
                  _buildTextField(
                    controller: remarksController,
                    label: "Remarks",
                    icon: Icons.comment_outlined,
                    maxLines: 3,
                  ),
                ]),
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: primaryGreen.withOpacity(0.3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: isCreating ? null : _handleStartAssembly,
                      child: isCreating
                          ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                          : const Text(
                        "START ASSEMBLY",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          if (isCreating)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonFormField<String>(
        value: availableProductTypes.contains(productType) ? productType : availableProductTypes.first,
        decoration: InputDecoration(
          icon: Icon(Icons.category_outlined, size: 22, color: primaryGreen),
          labelText: "Product Type",
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        items: availableProductTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => setState(() => productType = v!),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: primaryGreen.withOpacity(0.7),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          icon: Icon(icon, size: 22, color: primaryGreen),
          labelText: label,
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildDropdownWithAdd({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required VoidCallback onAdd,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(
                icon: Icon(icon, size: 22, color: primaryGreen),
                labelText: label,
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 24),
            color: primaryGreen,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(Icons.calendar_today_outlined, size: 22, color: primaryGreen),
      title: Text(
        startDate == null ? "Select Start Date" : startDate.toString().split(" ")[0],
        style: TextStyle(
          color: startDate == null ? Colors.grey[600] : Colors.black87,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) setState(() => startDate = picked);
      },
    );
  }

  void _handleStartAssembly() async {
    String serial = panelSerialController.text.trim();
    if (serial.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Panel Serial Number is required")),
      );
      return;
    }

    setState(() => isCreating = true);

    try {
      final panelData = {
        "panel_serial": serial,
        "product_type": productType,
        "prepared_by": preparedBy ?? "",
        "start_date": startDate?.toString().split(" ")[0] ?? "",
        "project_name": projectName ?? "",
        "reference_document": referenceDocController.text,
        "verified_by": verifiedBy ?? "",
        "remarks": remarksController.text,
        "status": "IN_PROGRESS"
      };

      if (!kIsWeb) {
        await DBHelper.insertPanel(
          serial,
          productType,
          preparedBy ?? "",
          startDate?.toString().split(" ")[0] ?? "",
          projectName ?? "",
          referenceDocController.text,
          verifiedBy ?? "",
          "",
          remarksController.text,
        );
      }

      await AzureService.syncFullPanel(
        serial,
        panelData: kIsWeb ? panelData : null,
        components: kIsWeb ? [] : null,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SectionDashboard(panelSerial: serial, productType: productType),
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => isCreating = false);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isCreating = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  void _showAddDialog(String title, String label, List<String> list) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
        content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            )
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => list.add(controller.text));
                Navigator.pop(context);
              }
            },
            child: const Text("ADD"),
          ),
        ],
      ),
    );
  }

  void addWorkerDialog() => _showAddDialog("Add Personnel", "Name", workersList);
  void addProjectDialog() => _showAddDialog("Add Project", "Project Name", projectList);
  void addVerifierDialog() => _showAddDialog("Add Verifier", "Name", verifierList);
}
