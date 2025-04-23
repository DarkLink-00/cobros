import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RegistrarPagoPage extends StatelessWidget {
  final String qrData;

  const RegistrarPagoPage({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    final double cuota = 15.0;
    final DateTime now = DateTime.now();
    final String fecha = DateFormat('yyyy-MM-dd').format(now); // Solo fecha
    final String hora = DateFormat('HH:mm').format(now); // Solo hora y minutos

    Map<String, String> extraerDatos(String data) {
      final Map<String, String> datos = {};
      final RegExp regExp = RegExp(
          r'Nombre:\s*(.*?)\s*Negocio:\s*(.*?)\s*Ubicacion:\s*(.*?)\s*Correo:\s*(.*?)\s*Rol:\s*(.*)',
          caseSensitive: false);

      final match = regExp.firstMatch(data);
      if (match != null) {
        datos['nombre'] = match.group(1)?.trim() ?? '';
        datos['negocio'] = match.group(2)?.trim() ?? '';
        datos['ubicacion'] = match.group(3)?.trim() ?? '';
        datos['correo'] = match.group(4)?.trim() ?? '';
        datos['rol'] = match.group(5)?.trim() ?? '';
      }
      return datos;
    }

    final datosExtraidos = extraerDatos(qrData);

    Future<void> registrarPago() async {
      try {
        await FirebaseFirestore.instance.collection('Pagos').add({
          'nombre': datosExtraidos['nombre'],
          'negocio': datosExtraidos['negocio'],
          'ubicacion': datosExtraidos['ubicacion'],
          'correo': datosExtraidos['correo'],
          'rol': datosExtraidos['rol'],
          'cuota': cuota,
          'fecha': fecha, // Guardamos solo la fecha
          'hora': hora, // Guardamos solo la hora
        });
      } catch (e) {
        print("❌ Error al registrar el pago: $e");
      }
    }

    return WillPopScope(
      onWillPop: () async {
        bool salir = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Salir sin registrar'),
            content: const Text('¿estas seguro de salir sin registrar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/cobro'),
                  child: const Text('Salir'))
            ],
          ),
        );
        return salir;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Registrar Pago")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Datos del QR:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(qrData,
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text("Fecha: $fecha", style: TextStyle(fontSize: 16)),
              Text("Hora: $hora", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text("Cuota: \$${cuota.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  registrarPago();
                  Navigator.pushReplacementNamed(context, "/cobro");
                },
                child: const Text("Registrar Pago"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
