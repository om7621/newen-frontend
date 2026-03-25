import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PanelQRScreen extends StatelessWidget {

  final String panelSerial;

  const PanelQRScreen({super.key, required this.panelSerial});

  @override
  Widget build(BuildContext context) {

    String qrData =
        "PanelID:$panelSerial\n"
        "URL:https://sites.google.com/view/newen-product-verify";

    return Scaffold(

      appBar: AppBar(
        title: const Text("Panel QR Code"),
      ),

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Panel Traceability QR",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 300,
            ),

            const SizedBox(height: 20),

            Text(
              panelSerial,
              style: const TextStyle(fontSize: 18),
            ),

          ],
        ),

      ),

    );
  }
}