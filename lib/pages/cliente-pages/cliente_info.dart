import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ClientInfo extends StatelessWidget {
  const ClientInfo({super.key});

  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('Usuarios')
        .doc(user.uid)
        .get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/client');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Informacion del Cliente')),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
              return const Center(child: Text('Error al cargar los datos'));
            }

            final userData = snapshot.data!;
            final qrString = userData['qrString'] ?? 'QR no disponible';

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${userData['nombre']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Correo: ${userData['correo']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Ubicacion: ${userData['ubicacion']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Negocio: ${userData['negocio']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Rol: ${userData['rol']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Código QR:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: qrString.isNotEmpty
                        ? QrImageView(
                            data: qrString,
                            version: QrVersions.auto,
                            size: 200,
                          )
                        : const Text(
                            'QR no disponible',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/client'),
                      child: const Text('Regresar'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
