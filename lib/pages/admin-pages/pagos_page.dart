import 'package:flutter/material.dart';

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
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: IntrinsicColumnWidth(),
                      2: IntrinsicColumnWidth(),
                      3: IntrinsicColumnWidth(),
                      4: IntrinsicColumnWidth(),
                      5: IntrinsicColumnWidth(),
                      6: IntrinsicColumnWidth(),
                      7: IntrinsicColumnWidth(),
                      8: IntrinsicColumnWidth(),
                      9: IntrinsicColumnWidth(),
                      10: IntrinsicColumnWidth(),
                      11: IntrinsicColumnWidth(),
                      12: IntrinsicColumnWidth(),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey[300]),
                        children: const [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'N°',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Nombre',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Negocio',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Ubicacion',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('D',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('L',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('M',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Mi',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('J',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('V',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('S',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Total Pagado',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Semana',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...List.generate(5, (index) {
                        return TableRow(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text('0000${index + 1}'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Guadalupe Hernandez'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Frituras'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Unidad E.Z.'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('0'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('15'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('0'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('15'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('0'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('15'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('0'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('\$ 45.00'),
                              ),
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Sem 20'),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
