import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRViewExample extends StatefulWidget {
  final Function(String result) onScan;

  const QRViewExample({Key? key, required this.onScan}) : super(key: key);

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مسح QR"),
        iconTheme: IconThemeData(
          size: 40,
        ),
      ),
      body: Stack(
        children: [
          // QR Scanner View
          QRView(
            key: qrKey,
            onQRViewCreated: (QRViewController controller) {
              this.controller = controller;
              controller.scannedDataStream.listen((scanData) {
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  widget.onScan(scanData.code ?? '');
                  Navigator.pop(
                      context); // Pop only if it's still the scanner page
                }
              });
            },
          ),

          // Custom Overlay with Smooth Corners
          Center(
            child: CustomPaint(
              painter: QRScannerOverlayPainter(
                color: Colors.green, // Change to preferred color
                borderRadius: 12, // Adjust roundness of corners
                borderThickness: 6, // Adjust thickness of lines
                boxSize: 250, // Size of the scanning area
              ),
              size: Size(250, 250), // Keep the size same as boxSize
            ),
          ),
        ],
      ),
    );
  }
}

// 🎨 CustomPainter for Smooth Corner Brackets
class QRScannerOverlayPainter extends CustomPainter {
  final Color color;
  final double borderThickness;
  final double borderRadius;
  final double boxSize;

  QRScannerOverlayPainter({
    required this.color,
    required this.borderThickness,
    required this.borderRadius,
    required this.boxSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = borderThickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double cornerLength = size.width * 0.2; // Length of each corner

    // Top Left Corner
    canvas.drawLine(Offset(0, borderRadius), Offset(0, cornerLength), paint);
    canvas.drawLine(Offset(borderRadius, 0), Offset(cornerLength, 0), paint);

    // Top Right Corner
    canvas.drawLine(Offset(size.width - borderRadius, 0),
        Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, borderRadius),
        Offset(size.width, cornerLength), paint);

    // Bottom Left Corner
    canvas.drawLine(Offset(0, size.height - borderRadius),
        Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(Offset(borderRadius, size.height),
        Offset(cornerLength, size.height), paint);

    // Bottom Right Corner
    canvas.drawLine(Offset(size.width - borderRadius, size.height),
        Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - borderRadius),
        Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
