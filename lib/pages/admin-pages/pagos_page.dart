import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPaymentsPage extends StatelessWidget {
  const RegisterPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/admin');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registro de Pagos'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Pagos').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No hay pagos registrados'));
            }

            List<Map<String, dynamic>> pagos = snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return {
                'nombre': data['nombre'] ?? 'Desconocido',
                'negocio': data['negocio'] ?? 'Sin negocio',
                'ubicacion': data['ubicacion'] ?? 'Sin ubicación',
                'fecha': data['fecha'] ?? '',
                'hora': data['hora'] ?? '',
                'cuota': data['cuota'] ?? 0,
              };
            }).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nombre')),
                  DataColumn(label: Text('Negocio')),
                  DataColumn(label: Text('Ubicación')),
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Hora')),
                  DataColumn(label: Text('Cuota')),
                ],
                rows: pagos.map((pago) {
                  return DataRow(cells: [
                    DataCell(Text(pago['nombre'])),
                    DataCell(Text(pago['negocio'])),
                    DataCell(Text(pago['ubicacion'])),
                    DataCell(Text(pago['fecha'])), // Muestra solo la fecha
                    DataCell(Text(pago['hora'])), // Muestra solo la hora
                    DataCell(Text('\$${pago['cuota']}')), // Muestra la cuota
                  ]);
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
