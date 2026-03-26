<<<<<<< HEAD
import 'package:flutter/material.dart';
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

  String productType = "CPS3000";
  String? preparedBy;
  String? projectName;
  String? verifiedBy;
  DateTime? startDate;

  List<String> workersList = ["Operator 1", "Operator 2"];
  List<String> projectList = ["Standard Project"];
  List<String> verifierList = ["Supervisor 1"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("New Assembly Setup"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Basic Information"),
            _buildCard([
              _buildTextField(
                controller: workOrderController,
                label: "Work Order No.",
                icon: Icons.assignment,
              ),
              const Divider(height: 1),
              _buildTextField(
                controller: panelSerialController,
                label: "Panel Serial Number",
                icon: Icons.qr_code,
              ),
              const Divider(height: 1),
              _buildDropdown(
                label: "Product Type",
                value: productType,
                items: ["CPS3000"],
                onChanged: (v) => setState(() => productType = v!),
                icon: Icons.category,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle("Project Details"),
            _buildCard([
              _buildDropdownWithAdd(
                label: "Project Name",
                value: projectName,
                items: projectList,
                onChanged: (v) => setState(() => projectName = v),
                onAdd: addProjectDialog,
                icon: Icons.business,
              ),
              const Divider(height: 1),
              _buildTextField(
                controller: referenceDocController,
                label: "Reference Document",
                icon: Icons.description,
              ),
              const Divider(height: 1),
              _buildDatePicker(),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle("Personnel"),
            _buildCard([
              _buildDropdownWithAdd(
                label: "Prepared By",
                value: preparedBy,
                items: workersList,
                onChanged: (v) => setState(() => preparedBy = v),
                onAdd: addWorkerDialog,
                icon: Icons.person_outline,
              ),
              const Divider(height: 1),
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
            _buildCard([
              _buildTextField(
                controller: remarksController,
                label: "Remarks",
                icon: Icons.comment_outlined,
                maxLines: 3,
              ),
            ]),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: _handleStartAssembly,
                child: const Text(
                  "START ASSEMBLY",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
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
          icon: Icon(icon, size: 20, color: Colors.green[700]),
          labelText: label,
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          icon: Icon(icon, size: 20, color: Colors.green[700]),
          labelText: label,
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
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
                icon: Icon(icon, size: 20, color: Colors.green[700]),
                labelText: label,
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 22),
            color: Colors.green[700],
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(Icons.calendar_today, size: 20, color: Colors.green[700]),
      title: Text(
        startDate == null ? "Select Start Date" : startDate.toString().split(" ")[0],
        style: TextStyle(
          color: startDate == null ? Colors.grey[600] : Colors.black,
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

    try {
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

      // Force an immediate sync to Azure so the panel exists in the cloud
      await AzureService.syncFullPanel(serial);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SectionDashboard(panelSerial: serial),
        ),
      );
    } catch (e) {
      // Even if sync fails, we proceed to dashboard (it will auto-sync later)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SectionDashboard(panelSerial: serial),
        ),
      );
    }
  }

  void _showAddDialog(String title, String label, List<String> list) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, decoration: InputDecoration(labelText: label)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
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
=======
import 'package:flutter/material.dart';
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

  String productType = "CPS3000";
  String? preparedBy;
  String? projectName;
  String? verifiedBy;
  DateTime? startDate;

  List<String> workersList = ["Operator 1", "Operator 2"];
  List<String> projectList = ["Standard Project"];
  List<String> verifierList = ["Supervisor 1"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("New Assembly Setup"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Basic Information"),
            _buildCard([
              _buildTextField(
                controller: workOrderController,
                label: "Work Order No.",
                icon: Icons.assignment,
              ),
              const Divider(height: 1),
              _buildTextField(
                controller: panelSerialController,
                label: "Panel Serial Number",
                icon: Icons.qr_code,
              ),
              const Divider(height: 1),
              _buildDropdown(
                label: "Product Type",
                value: productType,
                items: ["CPS3000"],
                onChanged: (v) => setState(() => productType = v!),
                icon: Icons.category,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle("Project Details"),
            _buildCard([
              _buildDropdownWithAdd(
                label: "Project Name",
                value: projectName,
                items: projectList,
                onChanged: (v) => setState(() => projectName = v),
                onAdd: addProjectDialog,
                icon: Icons.business,
              ),
              const Divider(height: 1),
              _buildTextField(
                controller: referenceDocController,
                label: "Reference Document",
                icon: Icons.description,
              ),
              const Divider(height: 1),
              _buildDatePicker(),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle("Personnel"),
            _buildCard([
              _buildDropdownWithAdd(
                label: "Prepared By",
                value: preparedBy,
                items: workersList,
                onChanged: (v) => setState(() => preparedBy = v),
                onAdd: addWorkerDialog,
                icon: Icons.person_outline,
              ),
              const Divider(height: 1),
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
            _buildCard([
              _buildTextField(
                controller: remarksController,
                label: "Remarks",
                icon: Icons.comment_outlined,
                maxLines: 3,
              ),
            ]),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: _handleStartAssembly,
                child: const Text(
                  "START ASSEMBLY",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
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
          icon: Icon(icon, size: 20, color: Colors.green[700]),
          labelText: label,
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          icon: Icon(icon, size: 20, color: Colors.green[700]),
          labelText: label,
          border: InputBorder.none,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
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
                icon: Icon(icon, size: 20, color: Colors.green[700]),
                labelText: label,
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 22),
            color: Colors.green[700],
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(Icons.calendar_today, size: 20, color: Colors.green[700]),
      title: Text(
        startDate == null ? "Select Start Date" : startDate.toString().split(" ")[0],
        style: TextStyle(
          color: startDate == null ? Colors.grey[600] : Colors.black,
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

    try {
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

      // Force an immediate sync to Azure so the panel exists in the cloud
      await AzureService.syncFullPanel(serial);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SectionDashboard(panelSerial: serial),
        ),
      );
    } catch (e) {
      // Even if sync fails, we proceed to dashboard (it will auto-sync later)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SectionDashboard(panelSerial: serial),
        ),
      );
    }
  }

  void _showAddDialog(String title, String label, List<String> list) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, decoration: InputDecoration(labelText: label)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
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
>>>>>>> 2dfef55a5e8fe09968b0a398029f9a91bda2f9af
}