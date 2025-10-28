import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'Register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onRegisterClick,
    required this.onLoginSuccess,
  });

  final VoidCallback onRegisterClick;
  final VoidCallback onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  final Color arancioSchermata = const Color(0xFFFFD6A5);
  final Color rossoArancio = const Color(0xFFFF5C39);
  final Color rossoArancio2 = const Color(0xFFFF7043);
  final Color gialloLogo = const Color(0xFFFFE066);
  final Color verdeLogo = const Color(0xFF66BB6A);

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      setState(() => _loading = true);
      await _login(email, password, remember: true);
    }
  }

  Future<void> _login(String email, String password, {bool remember = false}) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (remember) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "Errore sconosciuto";
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [arancioSchermata, Colors.white],
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: _loading
                ? const CircularProgressIndicator(color: Colors.orange)
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SizedBox(
                  height: 130,
                  width: 130,
                  child: Image.asset('assets/mylogo.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Benvenuto in',
                  style: TextStyle(
                    fontSize: 24,
                    color: rossoArancio2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [rossoArancio, gialloLogo, verdeLogo],
                  ).createShader(bounds),
                  child: const Text(
                    'StepOnTrack',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 45),

                // Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: rossoArancio),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: rossoArancio, width: 2),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: rossoArancio),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: rossoArancio, width: 2),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 5),

                // Remember me
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (val) =>
                          setState(() => _rememberMe = val ?? false),
                      activeColor: rossoArancio,
                    ),
                    const Text("Ricordami"),
                  ],
                ),
                const SizedBox(height: 16),

                // Login button
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: rossoArancio,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _login(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                      remember: _rememberMe,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],

                const SizedBox(height: 30),
                Divider(color: rossoArancio2, thickness: 1),
                const SizedBox(height: 28),

                Text(
                  "Non hai un account?",
                  style: TextStyle(color: rossoArancio, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegistrationScreen(
                          onBackClick: () => Navigator.pop(context),
                          onRegisterSuccess: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomeScreen()),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Registrati",
                    style: TextStyle(
                      color: rossoArancio,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
