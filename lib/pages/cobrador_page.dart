import 'package:flutter/material.dart';

class CobroPage extends StatelessWidget {
  const CobroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? shouldlogout = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Center(child: Text('Cerrar Sesión')),
              content: const Center(child: Text('¿Seguro de Cerrar Sesión?')),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text('Si'),
                ),
              ],
            );
          },
        );
        return shouldlogout ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cobrador'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.qr_code_scanner, size: 40),
                  title: const Text('Escaneo de QR'),
                  subtitle:
                      const Text('Accede al escaner para registrar pagos.'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/scanQR');
                  },
                ),
              ),
              const SizedBox(),
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.receipt_long, size: 40),
                  title: const Text('Cobros Hechos'),
                  subtitle:
                      const Text('Consulta los cobros realizados en el día.'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/payments');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
