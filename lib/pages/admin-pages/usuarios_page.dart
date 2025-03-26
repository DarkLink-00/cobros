import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cobros/pages/admin-pages/edit_users.dart';
import 'package:flutter/material.dart';

class ManageUserPage extends StatelessWidget {
  const ManageUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/admin');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manejo de Usuarios'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('Usuarios').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No hay usuarios registrados'),
                );
              }
              Map<String, List<DocumentSnapshot>> usersByRole = {
                'administrador': [],
                'cliente': [],
                'cobrador': []
              };
              for (var doc in snapshot.data!.docs) {
                String role = doc['rol'] ?? 'cliente';
                if (usersByRole.containsKey(role)) {
                  usersByRole[role]!.add(doc);
                }
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: usersByRole.entries
                    .where((entry) => entry.value.isNotEmpty)
                    .expand((entry) => [
                          Text(
                            entry.key.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...entry.value.map((userDoc) {
                            Map<String, dynamic> user =
                                userDoc.data() as Map<String, dynamic>;
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(user['nombre'] ?? 'Sin Nombre'),
                                subtitle: Text('Correo: ${user['correo']}'),
                                leading: const Icon(Icons.person),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditUsersPage(userId: userDoc.id),
                                    ),
                                  );
                                },
                              ),
                            );
                          })
                        ])
                    .toList(),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/addUser'),
          tooltip: 'Agregar Usuario',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
