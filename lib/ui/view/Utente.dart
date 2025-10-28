import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../viewModels/AuthViewModel.dart';
import 'MyTopAppBar.dart';
import 'MyBottomNavigationBar.dart';

class GestioneProfiloScreen extends StatefulWidget {
  const GestioneProfiloScreen({super.key});

  @override
  State<GestioneProfiloScreen> createState() => _GestioneProfiloScreenState();
}

class _GestioneProfiloScreenState extends State<GestioneProfiloScreen> {
  bool schermoAcceso = true;

  // Dati dummy per esempio
  final utente = {
    'nome': 'Mario',
    'cognome': 'Rossi',
    'username': 'mario.rossi',
    'dataCreazione': DateTime(2022, 1, 15)
  };

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Conferma logout'),
        content: const Text('Sei sicuro di voler uscire dall\'app?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // esegui logout e naviga a login
            },
            child: const Text('Esci', style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _onTapBottomNav(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/percorsi');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/classifiche');
        break;
      case 3:
      // siamo già qui
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
    DateFormat('dd/MM/yyyy').format(utente['dataCreazione'] as DateTime);

    return Scaffold(
      appBar: const MyTopBar(title: 'Account'),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 3, // Profilo
        onTap: _onTapBottomNav,
        onFabTap: () {
          Navigator.pushNamed(context, '/creaPercorso'); // se vuoi
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info profilo
            Row(
              children: [
                const Icon(Icons.account_circle, size: 52, color: Colors.orange),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${utente['nome']} ${utente['cognome']}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                      Text(utente['username'] as String,
                          style: const TextStyle(color: Colors.orange)),
                      Text('Membro dal: $formattedDate',
                          style: const TextStyle(color: Colors.orange)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Naviga a modifica profilo
                  },
                  icon: const Icon(Icons.edit, color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(),

            // Percorsi Preferiti
            ListTile(
              title: const Text('Percorsi Preferiti'),
              onTap: () {
                // Naviga a preferiti
              },
            ),
            const Divider(),

            // I miei percorsi
            ListTile(
              title: const Text('I miei percorsi'),
              onTap: () {
                // Naviga ai miei percorsi
              },
            ),
            const Divider(),

            // Switch schermo acceso
            SwitchListTile(
              title: const Text('Tieni acceso lo schermo durante la registrazione'),
              value: schermoAcceso,
              onChanged: (value) {
                setState(() {
                  schermoAcceso = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.green.withOpacity(0.5),
            ),
            const Divider(),

            // Logout
            ListTile(
              title: const Text('Esci'),
              onTap: () async {
                final authVM = context.read<AuthViewModel>();
                await authVM.logout();

                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
