import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth/auth_service.dart';
import 'login_toggle_button.dart';

/// Formulario para login y registro de usuario.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  static _LoginFormState of(BuildContext context) =>
      context.findAncestorStateOfType<_LoginFormState>()!;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final AuthService _authService = AuthService();

  bool isRegister = false;
  bool isLoading = false;
  String? _emailError;
  String? _passwordError;

  /// Envía el formulario (login o registro)
  Future<void> _submit() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    try {
      if (isRegister) {
        await _authService.register(email, pass);
      } else {
        await _authService.login(email, pass);
      }
    } on FirebaseAuthException catch (e) {
      await _handleAuthError(e);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error inesperado, intenta de nuevo.')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _handleAuthError(FirebaseAuthException e) async {
    if (e.code == 'user-not-found') {
      await _showUserNotFoundDialog();
    } else if (e.code == 'wrong-password') {
      setState(() {
        _passwordError = 'La contraseña es incorrecta.';
      });
    } else if (e.code == 'invalid-credential') {
      setState(() {
        _passwordError =
            'La información de autenticación no es válida o ha expirado.';
      });
    } else {
      setState(() {
        _emailError = e.code == 'invalid-email'
            ? 'El formato del correo no es válido.'
            : null;
        if (e.code != 'invalid-email') {
          _passwordError = e.message ?? 'Ha ocurrido un error.';
        }
      });
    }
    _formKey.currentState!.validate();
  }

  Future<void> _showUserNotFoundDialog() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Usuario no encontrado'),
        content: const Text(
            'No existe ningún usuario con ese correo. ¿Deseas registrarte?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => isRegister = true);
              Navigator.of(context).pop();
            },
            child: const Text('Registrarse'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Text(
          isRegister ? 'Registro' : 'Iniciar sesión', style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold,
            color: Colors.blueGrey),
       ),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: Text(isRegister ? 'Registrar' : 'Ingresar'),
                      ),
                    ),
              LoginToggleButton(onToggle: _toggleRegister, isRegister: isRegister),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailCtrl,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email),
        errorText: _emailError,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (_emailError != null) return _emailError;
        if (value == null || value.isEmpty) {
          return 'El email es obligatorio.';
        }
        final pattern = r'^[^@]+@[^@]+\.[^@]+';
        if (!RegExp(pattern).hasMatch(value)) {
          return 'Ingresa un email válido.';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passCtrl,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        prefixIcon: const Icon(Icons.lock),
        errorText: _passwordError,
      ),
      obscureText: true,
      validator: (value) {
        if (_passwordError != null) return _passwordError;
        if (value == null || value.isEmpty) {
          return 'La contraseña es obligatoria.';
        }
        if (value.length < 6) {
          return 'Mínimo 6 caracteres.';
        }
        return null;
      },
    );
  }

  void _toggleRegister() {
    setState(() {
      isRegister = !isRegister;
      _emailError = null;
      _passwordError = null;
    });
  }
}
