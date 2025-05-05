import 'package:cobros/pages/cobrador-pages/regist_pay.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'dart:typed_data';
import 'dart:math';

class ScanQRPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ScanQRPage({super.key, required this.cameras});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  CameraController? _cameraController;
  late BarcodeScanner _barcodeScanner;
  bool _isProcessing = false;
  String detectedCode = "Escanea un código QR...";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _barcodeScanner = BarcodeScanner();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isNotEmpty) {
      _cameraController = CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await _cameraController!.initialize();
      print("✅ Cámara inicializada correctamente");
      setState(() {});
      _startImageStream();
    } else {
      print("❌ No se encontraron cámaras disponibles");
    }
  }

  void _startImageStream() {
    if (_cameraController == null) {
      print("❌ Cámara no inicializada.");
      return;
    }
    print("📸 Iniciando flujo de imágenes...");

    _cameraController!.startImageStream((CameraImage image) async {
      print("📸 Imagen recibida con formato: ${image.format.group}");
      if (_isProcessing) return;
      _isProcessing = true;

      try {
        final inputImage = _convertCameraImageToInputImage(image);
        if (inputImage == null) {
          print("❌ No se pudo convertir la imagen.");
          _isProcessing = false;
          return;
        }

        final barcodes = await _barcodeScanner.processImage(inputImage);
        print("🔍 Barcodes detectados: ${barcodes.length}");

        if (barcodes.isNotEmpty) {
          for (var barcode in barcodes) {
            if (barcode.format == BarcodeFormat.qrCode) {
              final scannedData = barcode.displayValue ??
                  barcode.rawValue ??
                  "Código no válido";

              print("✅ Código detectado: $scannedData");

              if (scannedData != "Código no válido") {
                setState(() {
                  detectedCode = scannedData;
                });

                print("📌 Navegando a RegistrarPagoPage...");
                if (mounted) {
                  _navigateToRegistrarPago(scannedData);
                }
              }
              break; // Solo tomamos el primer QR detectado
            }
          }
        } else {
          print("⚠ No se detectaron códigos QR.");
        }
      } catch (e) {
        print("❌ Error al procesar la imagen: $e");
      }
      await Future.delayed(Duration(milliseconds: 500));

      _isProcessing = false;
    });
  }

  InputImage? _convertCameraImageToInputImage(CameraImage image) {
    try {
      final Uint8List bytes = _convertYUV420ToNV21(image);

      final metadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      print("❌ Error al convertir imagen de la cámara: $e");
      return null;
    }
  }

  Uint8List _convertYUV420ToNV21(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int ySize = width * height;
    final int uvSize = ySize ~/ 4;

    final Uint8List nv21 = Uint8List(ySize + 2 * uvSize);
    final Uint8List yBuffer = image.planes[0].bytes;
    final Uint8List uBuffer = image.planes[1].bytes;
    final Uint8List vBuffer = image.planes[2].bytes;

    nv21.setRange(0, ySize, yBuffer);
    int uvIndex = ySize;
    int uIndex = 0;
    int vIndex = 0;

    for (int i = 0; i < uvSize; i++) {
      nv21[uvIndex++] = vBuffer[vIndex++];
      nv21[uvIndex++] = uBuffer[uIndex++];
    }

    return nv21;
  }

  void _navigateToRegistrarPago(String qrData) {
    if (!mounted) return;

    print("📌 Navegando a RegistrarPagoPage con: $qrData");
    _cameraController?.stopImageStream();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrarPagoPage(qrData: qrData),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_cameraController != null &&
            _cameraController!.value.isStreamingImages) {
          await _cameraController?.stopImageStream();
        }
        Navigator.pushReplacementNamed(context, '/cobro');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Escaneo de QR')),
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: _cameraController != null &&
                          _cameraController!.value.isInitialized
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.8,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                    width: _cameraController!
                                        .value.previewSize!.height,
                                    height: _cameraController!
                                        .value.previewSize!.width,
                                    child: CameraPreview(_cameraController!)),
                              )),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
