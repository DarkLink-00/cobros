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
              const SnackBar(content: Text('Rol de usuario no valido')),
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

  void _showNotAvailable(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Funcionalidad no Disponible'),
          content: const Text('Esta funcionalidad aún no esta disponible'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // Logo o encabezado
                  const Center(
                    child: Text(
                      'Iniciar Sesión',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Campo de correo electrónico
                  CustomTextField(
                    labelText: 'Correo Electrónico',
                    isPassword: false,
                    controller: _correoControl,
                  ),
                  const SizedBox(height: 16),
                  // Campo de contraseña
                  CustomTextField(
                    labelText: 'Contraseña',
                    isPassword: true,
                    controller: _passwordControl,
                  ),
                  const SizedBox(height: 24),
                  // Botón de inicio de sesión
                  CustomElevatedButton(
                    text: 'Iniciar Sesión',
                    color: Colors.blue,
                    icon: Icons.login,
                    onPressed: _signInWithEmailAndPassword,
                    //() => Navigator.pushReplacementNamed(context, '/admin'),
                  ),
                  const SizedBox(height: 16),
                  // Botón de inicio de sesión con Google
                  CustomElevatedButton(
                    text: 'Iniciar Sesión con Google',
                    color: Colors.grey,
                    icon: Icons.g_mobiledata,
                    onPressed: () => _showNotAvailable(context),
                  ),
                  const SizedBox(height: 16),
                  // Botón de inicio de sesión con Facebook
                  CustomElevatedButton(
                    text: 'Iniciar Sesión con Facebook',
                    color: Colors.blueGrey,
                    icon: Icons.facebook,
                    onPressed: () => _showNotAvailable(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget personalizado para los campos de texto
class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    required this.labelText,
    required this.isPassword,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      obscureText: isPassword,
    );
  }
}

// Widget personalizado para los botones elevados
class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    required this.text,
    required this.color,
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

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
