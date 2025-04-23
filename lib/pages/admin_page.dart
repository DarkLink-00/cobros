import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? shouldLogout = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Cerrar Sesión'),
              content: const Text('¿Seguro que quieres cerrar sesión?'),
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
        return shouldLogout ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Administrador'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: ListTile(
                  title: const Text('Usuarios'),
                  subtitle: const Text('Manejo de Usuarios'),
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/manageUsers'),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Card(
                child: ListTile(
                  title: const Text('Pagos'),
                  subtitle: const Text('Registrio de Pagos'),
                  onTap: () => Navigator.pushReplacementNamed(
                      context, '/registPayments'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
