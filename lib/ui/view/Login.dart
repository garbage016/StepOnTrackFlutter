import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/UserState.dart';
import '../../viewModels/AuthViewModel.dart';


class LoginScreen extends StatefulWidget {
  final VoidCallback onRegisterClick;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.onRegisterClick,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);
    final userState = viewModel.userState;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA726), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              SizedBox(
                height: 130,
                width: 130,
                child: Image.asset('assets/mylogo.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Benvenuto in',
                style: TextStyle(fontSize: 24, color: Color(0xFFD84315)),
              ),
              const SizedBox(height: 10),
              Text(
                'StepOnTrack',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFFFEB3B), Color(0xFF66BB6A)],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
              const SizedBox(height: 45),

              // EMAIL
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // PASSWORD
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // LOGIN BUTTON
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.login(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD84315),
                  ),
                  child: const Text('Login'),
                ),
              ),

              const SizedBox(height: 16),

              // Stato login
              if (userState is Loading) const Text('Accesso in corso...'),
              if (userState is ErrorState)
                Text(
                  'Errore: ${userState.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              if (userState is Authenticated)
              // Naviga automaticamente a Home
                Builder(builder: (_) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onLoginSuccess();
                  });
                  return const SizedBox();
                }),

              const SizedBox(height: 28),
              const Divider(color: Color(0xFFD84315), thickness: 1),
              const SizedBox(height: 28),

              const Text(
                'Non hai un account?',
                style: TextStyle(color: Color(0xFFD84315), fontSize: 16),
              ),
              GestureDetector(
                onTap: widget.onRegisterClick,
                child: const Text(
                  'Registrati',
                  style: TextStyle(
                    color: Color(0xFFD84315),
                    fontSize: 16,
                    decoration: TextDecoration.underline,
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
