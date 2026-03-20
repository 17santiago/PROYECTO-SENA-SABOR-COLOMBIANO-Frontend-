import 'package:flutter/material.dart';
import 'package:frontend_recetas/screens/auth/widget/login_widget.dart';
import 'package:frontend_recetas/screens/home/main_screen.dart';
import 'package:frontend_recetas/services/login_services.dart';
import 'package:frontend_recetas/models/login_result.dart'; // 👈 Importa el modelo

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  bool _obscurePassword = true;

  void login() async {
    setState(() => loading = true);

    // ✅ Ahora recibimos un LoginResult, no solo un bool
    final result = await LoginServices.login(
      emailController.text.trim(), // Bueno limpiar espacios
      passwordController.text,
    );

    setState(() => loading = false);

    if (result.success) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
          (route) => false,
        );
      }
    } else {
      // ❌ Determinar el mensaje según el tipo de error
      String errorMessage;
      switch (result.errorType) {
        case LoginErrorType.emailNotFound:
          errorMessage = result.message ?? 'El correo no está registrado';
          break;
        case LoginErrorType.wrongPassword:
          errorMessage = result.message ?? 'Contraseña incorrecta';
          break;
        case LoginErrorType.other:
          errorMessage = result.message ?? 'Error al iniciar sesión';
          break;
        default:
          errorMessage = 'Error desconocido';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              customInput(
                label: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 20),
              customInput(
                label: 'Contraseña',
                controller: passwordController,
                obscure: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const Spacer(),
              loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: login,
                        child: const Text(
                          'Entrar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}