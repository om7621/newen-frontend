import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool isScanCompleted = false;
  double _zoomFactor = 1.0; // In 5.x, zoom starts at 1.0
  
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.unrestricted,
    facing: CameraFacing.back,
    formats: [BarcodeFormat.all],
  );

  @override
  Widget build(BuildContext context) {
    final double windowWidth = 320.0;
    final double windowHeight = 160.0;
    
    final Rect scanWindow = Rect.fromCenter(
      center: Offset(
        MediaQuery.of(context).size.width / 2,
        MediaQuery.of(context).size.height / 2,
      ),
      width: windowWidth,
      height: windowHeight,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("High-Density Scanner"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          // Zoom Toggle
          IconButton(
            icon: Icon(_zoomFactor == 1.0 ? Icons.zoom_in : Icons.zoom_out),
            onPressed: () {
              setState(() {
                _zoomFactor = _zoomFactor == 1.0 ? 2.0 : 1.0;
              });
              cameraController.setZoomScale(_zoomFactor); // Use setZoomScale for version 5.x
            },
          ),
          // Torch Toggle using the standard ValueListenableBuilder
          ValueListenableBuilder(
            valueListenable: cameraController,
            builder: (context, state, child) {
              final bool isTorchOn = state.torchState == TorchState.on;
              return IconButton(
                icon: Icon(
                  isTorchOn ? Icons.flash_on : Icons.flash_off,
                  color: isTorchOn ? Colors.yellow : Colors.white,
                ),
                onPressed: () => cameraController.toggleTorch(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            scanWindow: scanWindow,
            onDetect: (capture) {
              if (isScanCompleted) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  isScanCompleted = true;
                  Navigator.pop(context, code);
                  break;
                }
              }
            },
          ),
          CustomPaint(
            painter: ScannerOverlayPainter(scanWindow: scanWindow),
            child: Container(),
          ),
          Center(
            child: Container(
              width: windowWidth,
              height: windowHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Center(
            child: Container(
              width: windowWidth - 20,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 4, spreadRadius: 1)
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.70,
            left: 20,
            right: 20,
            child: Center(
              child: Column(
                children: [
                  const Text(
                    "Align Barcode with Red Line",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _zoomFactor == 1.0 ? "Tap Zoom for tiny barcodes" : "Zoom Active - Keep steady",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;
  ScannerOverlayPainter({required this.scanWindow});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(12)));
    final path = Path.combine(PathOperation.difference, backgroundPath, cutoutPath);
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}