import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedRole = 'cliente';
  final List<String> _roles = ['administrador', 'cliente', 'cobrador'];

  bool _isLoading = false;
  bool _passwordVisible = false;

  String? _qrString;

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (_qrString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Genera el código QR antes de registrar al usuario')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Crear usuario en Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text.trim(),
      );

      // Obtener el UID del usuario
      String uid = userCredential.user!.uid;

      // Guardar datos en Firestore
      final userData = {
        'nombre': _nameController.text.trim(),
        'correo': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'rol': _selectedRole,
      };

      // Agregar campos adicionales si el rol es Cliente
      if (_selectedRole == 'cliente') {
        userData.addAll({
          'negocio': _businessController.text.trim(),
          'ubicacion': _locationController.text.trim(),
          'qrString': _qrString!,
        });
      }
      await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(uid)
          .set(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado exitosamente')),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/manageUsers');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _generateQrCode() {
    if (_emailController.text.trim().isEmpty ||
        _nameController.text.trim().isEmpty ||
        _businessController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Ingresa un correo para generar el QR')));
      return;
    }
    setState(() {
      _qrString = '''
Nombre: ${_nameController.text.trim()}
Negocio: ${_businessController.text.trim()}
Ubicacion: ${_locationController.text.trim()}
Correo: ${_emailController.text.trim()}
Rol: $_selectedRole
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/manageUsers');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Agregar Usuario')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildDropdownField(),
                    const SizedBox(height: 12),
                    _buildTextField(_nameController, 'Nombre'),
                    const SizedBox(height: 12),
                    if (_selectedRole == 'cliente')
                      _buildTextField(_businessController, 'Negocio'),
                    const SizedBox(height: 12),
                    if (_selectedRole == 'cliente')
                      _buildTextField(_locationController, 'Ubicación'),
                    const SizedBox(height: 12),
                    _buildTextField(_emailController, 'Correo'),
                    const SizedBox(height: 12),
                    _buildPasswordField(),
                    const SizedBox(height: 20),
                    if (_selectedRole == 'cliente') ...[
                      ElevatedButton(
                        onPressed: _generateQrCode,
                        child: const Text('Generar QR'),
                      ),
                      const SizedBox(height: 20),
                      _qrString != null && _qrString!.isNotEmpty
                          ? QrImageView(
                              data: _qrString!,
                              version: QrVersions.auto,
                              size: 200,
                            )
                          : const Text(
                              'Genera un QR para Visualizarlo',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                      const SizedBox(height: 20),
                    ],
                    ElevatedButton(
                      onPressed: _registerUser,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.blue)
                          : const Text('Registrar Usuario'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Campo requerido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            }),
      ),
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Mínimo 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      decoration: const InputDecoration(
        labelText: 'Rol',
        border: OutlineInputBorder(),
      ),
      items: _roles
          .map((rol) => DropdownMenuItem(value: rol, child: Text(rol)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedRole = value!;
        });
      },
    );
  }
}
