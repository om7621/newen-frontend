import 'package:flutter/material.dart';
import 'create_panel_screen.dart';
import 'panel_list_screen.dart';
import 'master_report_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.green.shade50;
    final Color primaryGreen = const Color(0xFF1B5E20);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Newen Traceability System",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.8),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Brand Identity
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryGreen.withOpacity(0.12),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            height: 110,
                            child: Image.asset(
                              "assets/logo/newen_logo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        
                        _buildMenuButton(
                          context,
                          title: "Create New Panel",
                          subtitle: "Setup a new assembly project",
                          icon: Icons.add_rounded,
                          color: primaryGreen,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreatePanelScreen()),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildMenuButton(
                          context,
                          title: "Continue Panel",
                          subtitle: "Manage existing work in progress",
                          icon: Icons.inventory_2_outlined,
                          color: Colors.blueGrey.shade700,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PanelListScreen()),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildMenuButton(
                          context,
                          title: "Master Excel Report",
                          subtitle: "Download full database summary",
                          icon: Icons.description_outlined,
                          color: Colors.orange.shade900,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MasterReportScreen()),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Refined Minimalist Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  const Text(
                    "Newen System Pvt. Ltd. © 2026",
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "All Rights are Reserved",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 340),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.green.shade100.withOpacity(0.5), width: 1),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 26, color: color),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}
