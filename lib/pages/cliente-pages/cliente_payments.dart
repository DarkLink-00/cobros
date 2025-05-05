import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientPaymentsPage extends StatelessWidget {
  const ClientPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/client');
          return false;
        },
        child: const Scaffold(
          body: Center(child: Text("Inicia sesion para ver tus pagos")),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/client');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Mis pagos")),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Pagos')
                .where('correo', isEqualTo: user.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error al cargar los datos'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No tienes pagos registrados'));
              }

              var pagos = snapshot.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return {
                  'fecha': data['fecha'] ?? 'Sin Fecha',
                  'hora': data['hora'] ?? 'Sin Hora',
                  'cuota': data['cuota'] ?? 0,
                };
              }).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Hora')),
                    DataColumn(label: Text('Cuota')),
                  ],
                  rows: pagos.map((pago) {
                    return DataRow(cells: [
                      DataCell(Text(pago['fecha'])),
                      DataCell(Text(pago['hora'])),
                      DataCell(Text('\$${pago['cuota'].toStringAsFixed(2)}')),
                    ]);
                  }).toList(),
                ),
              );
            }),
      ),
    );
  }
}
