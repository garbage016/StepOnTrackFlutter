import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool loading = true;

  String nome = '';
  String cognome = '';
  String username = '';
  DateTime? dataCreazione;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        setState(() {
          username = "Nessun utente loggato";
          loading = false;
        });
        return;
      }
      final query = await FirebaseFirestore.instance
          .collection('Utente')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        setState(() {
          nome = data['nome'] ?? '';
          cognome = data['cognome'] ?? '';
          username = data['username'] ?? 'Sconosciuto';
          dataCreazione = (data['dataCreazione'] is Timestamp)
              ? (data['dataCreazione'] as Timestamp).toDate()
              : null;
          loading = false;
        });
      } else {
        setState(() {
          username = 'Utente non trovato';
          loading = false;
        });
      }
    } catch (e) {
      print("Errore caricamento profilo: $e");
      setState(() {
        username = 'Errore caricamento';
        loading = false;
      });
    }
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
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyTopBar(title: 'Account'),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 3,
        onTap: _onTapBottomNav,
        onFabTap: () => Navigator.pushNamed(context, '/creaPercorso'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle,
                    size: 52, color: Colors.orange),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$nome $cognome",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Text(username,
                          style: const TextStyle(color: Colors.orange)),
                      if (dataCreazione != null)
                        Text(
                          'Membro dal: ${DateFormat('dd/MM/yyyy').format(dataCreazione!)}',
                          style: const TextStyle(color: Colors.orange),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Naviga a modifica profilo
                    Navigator.pushNamed(context, '/modificaProfilo');
                  },
                  icon: const Icon(Icons.edit, color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(),

            ListTile(
              title: const Text('Percorsi Preferiti'),
              onTap: () {},
            ),
            const Divider(),

            ListTile(
              title: const Text('I miei percorsi'),
              onTap: () {},
            ),
            const Divider(),

            SwitchListTile(
              title: const Text(
                  'Tieni acceso lo schermo durante la registrazione'),
              value: schermoAcceso,
              onChanged: (value) =>
                  setState(() => schermoAcceso = value),
              activeColor: Colors.white,
              activeTrackColor: Colors.green.withOpacity(0.5),
            ),
            const Divider(),

            ListTile(
              title: const Text('Esci'),
              onTap: () async {
                final authVM = context.read<AuthViewModel>();
                await authVM.logout();

                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
