import 'package:flutter/material.dart';
import 'create_panel_screen.dart';
import 'panel_list_screen.dart';
import 'master_report_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Professional Light Green Background
    final Color backgroundColor = Colors.green.shade50; 

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Newen Traceability System",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
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
                        // Brand Identity with elevated container
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            height: 120,
                            child: Image.asset(
                              "assets/logo/newen_logo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        
                        // Main Actions - Pure White Tiles for contrast
                        _buildMenuButton(
                          context,
                          title: "Create New Panel",
                          icon: Icons.add_circle_outline_rounded,
                          color: const Color(0xFF1B5E20),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CreatePanelScreen()),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildMenuButton(
                          context,
                          title: "Continue Panel",
                          icon: Icons.edit_note_rounded,
                          color: Colors.blueGrey.shade700,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PanelListScreen()),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildMenuButton(
                          context,
                          title: "Master Excel Report",
                          icon: Icons.analytics_outlined,
                          color: Colors.orange.shade800,
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
            
            // Refined Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Newen System Pvt. Ltd. © 2026",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "All Rights are Reserved",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                      letterSpacing: 0.5,
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
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 320),
      child: Container( // Shadow wrapper
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Pure white tile
            foregroundColor: color,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.green.shade100, width: 1.0),
            ),
          ).copyWith(
            overlayColor: MaterialStateProperty.all(color.withOpacity(0.05)),
          ),
          onPressed: onTap,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 24),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
