import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _correoControl = TextEditingController();
  final TextEditingController _passwordControl = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _correoControl.text.trim(),
        password: _passwordControl.text.trim(),
      );

      String? userId = userCredential.user?.uid;

      if (userId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          String role = userDoc.get('rol');
          if (role == 'administrador') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else if (role == 'cliente') {
            Navigator.pushReplacementNamed(context, '/client');
          } else if (role == 'cobrador') {
            Navigator.pushReplacementNamed(context, '/cobro');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Rol de usuario no válido')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario NO Encontrado')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  /*void _showNotAvailable(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Funcionalidad no Disponible'),
          content: const Text('Esta funcionalidad aún no está disponible'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Iniciar Sesión',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                      labelText: 'Correo Electrónico',
                      isPassword: false,
                      controller: _correoControl),
                  const SizedBox(height: 16),
                  CustomTextField(
                      labelText: 'Contraseña',
                      isPassword: true,
                      controller: _passwordControl),
                  const SizedBox(height: 50),
                  CustomElevatedButton(
                      text: 'Iniciar Sesión',
                      color: theme.primaryColor,
                      icon: Icons.login,
                      onPressed: _signInWithEmailAndPassword),
                  /*const SizedBox(height: 16),
                  CustomElevatedButton(
                      text: 'Iniciar Sesión con Google',
                      color: Colors.grey,
                      icon: Icons.g_mobiledata,
                      onPressed: () => _showNotAvailable(context)),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                      text: 'Iniciar Sesión con Facebook',
                      color: Colors.blueGrey,
                      icon: Icons.facebook,
                      onPressed: () => _showNotAvailable(context)),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField(
      {required this.labelText,
      required this.isPassword,
      required this.controller,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      obscureText: isPassword,
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomElevatedButton(
      {required this.text,
      required this.color,
      required this.icon,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
