import 'package:flutter/material.dart';

/// Botón para alternar entre login y registro.
class LoginToggleButton extends StatelessWidget {
  final VoidCallback onToggle;
  final bool isRegister;

  const LoginToggleButton({
    super.key,
    required this.onToggle,
    required this.isRegister,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onToggle,
      child: Text(
        isRegister
            ? '¿Ya tienes cuenta? Inicia sesión'
            : '¿No tienes cuenta? Regístrate',
      ),
    );
  }
}
