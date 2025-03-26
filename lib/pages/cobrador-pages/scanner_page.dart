import 'package:flutter/material.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Escaner')),
    );
  }
}
