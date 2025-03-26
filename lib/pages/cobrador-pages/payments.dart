import 'package:flutter/material.dart';

class PaymentsMadePage extends StatelessWidget {
  const PaymentsMadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/cobro');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cobros Hechos'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/cobrador');
            },
          ),
        ),
        body: const Center(
          child: Text('Aquí se mostrarán los cobros realizados.'),
        ),
      ),
    );
  }
}
