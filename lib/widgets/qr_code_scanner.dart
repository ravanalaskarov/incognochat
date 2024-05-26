import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/controllers/text_field_value_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends ConsumerStatefulWidget {
  const QrCodeScanner({super.key});

  @override
  ConsumerState<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends ConsumerState<QrCodeScanner> {
  final _controller = MobileScannerController();
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
              ref
                  .read(textFiledValueControllerProvider.notifier)
                  .changeValue(barcode.rawValue!);
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }
}
