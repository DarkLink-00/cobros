import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUsersPage extends StatefulWidget {
  final String userId;

  const EditUsersPage({super.key, required this.userId});

  @override
  State<EditUsersPage> createState() => _EditUsersPageState();
}

class _EditUsersPageState extends State<EditUsersPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _negocioController = TextEditingController();

  String _selectedRol = 'cliente';
  String _correo = '';
  String _password = '**********';
  bool _isLoading = true;
  bool _passwordVisible = false;
  final List<String> _roles = ['administrador', 'cliente', 'cobrador'];

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(widget.userId)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _nombreController.text = userData['nombre'] ?? '';
          _ubicacionController.text = userData['ubicacion'] ?? '';
          _negocioController.text = userData['negocio'] ?? '';
          _selectedRol = userData['rol'] ?? 'Usuario';
          _correo = userData['correo'] ?? 'No disponible';
          _password = userData['password'] ?? '********';
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar datos: $e'),
        ),
      );
    }
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(widget.userId)
          .update({
        'nombre': _nombreController.text,
        'ubicacion': _ubicacionController.text,
        'negocio': _negocioController.text,
        'rol': _selectedRol,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario actualizado correctamente'),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Usuario')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildReadOnlyField('Correo', _correo),
                    const SizedBox(height: 12),
                    _buildPasswordField(),
                    const SizedBox(height: 12),
                    _buildTextField(_nombreController, 'Nombre'),
                    const SizedBox(height: 12),
                    _buildTextField(_ubicacionController, 'Ubicacion'),
                    const SizedBox(height: 12),
                    _buildTextField(_negocioController, 'Negocio'),
                    const SizedBox(height: 12),
                    _buildDropdownField(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _guardarCambios,
                      child: const Text('Guardar Cambios'),
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

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedRol,
      decoration: const InputDecoration(
        labelText: 'Rol',
        border: OutlineInputBorder(),
      ),
      items: _roles
          .map((rol) => DropdownMenuItem(value: rol, child: Text(rol)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedRol = value!;
        });
      },
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      initialValue: _password,
      readOnly: true,
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
          },
        ),
      ),
    );
  }
}
