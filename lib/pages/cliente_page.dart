import 'package:flutter/material.dart';

class ClientePage extends StatelessWidget {
  const ClientePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? shouldLogout = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Cerrar Sesión'),
              content: const Center(
                child: Text('¿Seguro que desea cerrar sesión?'),
              ),
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
                    child: const Text('Si'))
              ],
            );
          },
        );
        return shouldLogout ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cliente'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.person, size: 40),
                  title: const Text('Mi información'),
                  subtitle: const Text('Consulta tus datos de Usuario'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/clientInfo');
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.receipt, size: 40),
                  title: const Text('Pagos Hechos'),
                  subtitle: const Text('Consulta tu historial de pagos'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/clientPayments');
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
