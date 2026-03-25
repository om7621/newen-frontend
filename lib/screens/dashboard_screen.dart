import 'package:flutter/material.dart';
import 'create_panel_screen.dart';
import 'panel_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel Dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 140,
              child: Image.asset(
                "assets/logo/newen_logo.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            // CREATE NEW PANEL
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreatePanelScreen(),
                    ),
                  );
                },
                label: const Text("Create New Panel"),
              ),
            ),
            const SizedBox(height: 20),
            // CONTINUE PANEL
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PanelListScreen(),
                    ),
                  );
                },
                label: const Text("Continue Panel"),
              ),
            ),
            const SizedBox(height: 40),
            // STATUS TEXT
            const Icon(Icons.cloud_done, color: Colors.green, size: 30),
            const SizedBox(height: 8),
            const Text(
              "Auto-Sync Active",
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Saving changes every 5 seconds",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
