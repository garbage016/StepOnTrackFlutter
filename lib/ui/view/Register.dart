import 'package:flutter/material.dart';
import '../../repository/AuthRepository.dart';
import '../theme/Color.dart';

class RegistrationScreen extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onRegisterSuccess;

  const RegistrationScreen({
    super.key,
    required this.onBackClick,
    required this.onRegisterSuccess,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cognomeController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  bool isLoading = false;
  bool usernameDisponibile = true;
  String usernameErrore = '';

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_checkUsername);
  }

  void _checkUsername() async {
    String username = usernameController.text.trim();
    if (username.isEmpty) {
      setState(() {
        usernameDisponibile = true;
        usernameErrore = '';
      });
      return;
    }

    bool disponibile = await _authRepository.controlloUsername(username);
    setState(() {
      usernameDisponibile = disponibile;
      usernameErrore = disponibile ? '' : 'Username già in uso';
    });
  }

  Future<void> _selectBirthDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 14)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      birthDateController.text =
      '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || !usernameDisponibile) return;

    setState(() => isLoading = true);

    final result = await _authRepository.register(
      emailController.text.trim(),
      passwordController.text,
    );

    if (result.success == true) {
      await _authRepository.saveUserData(
        nome: nomeController.text.trim(),
        cognome: cognomeController.text.trim(),
        username: usernameController.text.trim(),
        dataNascita: birthDateController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      widget.onRegisterSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error ?? 'Errore sconosciuto')),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: standardWhite,
      appBar: AppBar(
        title: const Text('Registrazione'),
        backgroundColor: arancioSchermata,
        foregroundColor: standardWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBackClick,
          color: standardWhite,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Username
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: arancioSchermata),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: arancioSchermata),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: rossoArancio, width: 2),
                  ),
                  errorText: usernameDisponibile ? null : usernameErrore,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inserisci username';
                  }
                  if (value.trim().length > 15) {
                    return 'Max 15 caratteri';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nome
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: arancioSchermata),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: arancioSchermata),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: rossoArancio, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inserisci nome';
                  }
                  if (value.trim().length > 15) {
                    return 'Max 15 caratteri';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Cognome
              TextFormField(
                controller: cognomeController,
                decoration: InputDecoration(
                  labelText: 'Cognome',
                  labelStyle: TextStyle(color: arancioSchermata),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: arancioSchermata),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: rossoArancio, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inserisci cognome';
                  }
                  if (value.trim().length > 15) {
                    return 'Max 15 caratteri';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Data di nascita
              TextFormField(
                controller: birthDateController,
                decoration: InputDecoration(
                  labelText: 'Data di nascita',
                  hintText: 'gg/mm/aaaa',
                  labelStyle: TextStyle(color: arancioSchermata),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: arancioSchermata),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: rossoArancio, width: 2),
                  ),
                ),
                readOnly: true,
                onTap: _selectBirthDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Seleziona data di nascita';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: arancioSchermata),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: arancioSchermata),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: rossoArancio, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Inserisci email';
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Email non valida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: arancioSchermata),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: arancioSchermata),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: rossoArancio, width: 2),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Almeno 6 caratteri';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Bottone registrazione
              isLoading
                  ? const CircularProgressIndicator(color: rossoArancio)
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: arancioSchermata,
                    foregroundColor: standardWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Crea account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
