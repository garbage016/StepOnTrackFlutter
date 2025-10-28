import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ModificaProfiloScreen extends StatefulWidget {
  const ModificaProfiloScreen({super.key});

  @override
  State<ModificaProfiloScreen> createState() => _ModificaProfiloScreenState();
}

class _ModificaProfiloScreenState extends State<ModificaProfiloScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cognomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _caricaDatiUtente();
  }

  Future<void> _caricaDatiUtente() async {
    final user = auth.currentUser;
    if (user == null) return;

    final snapshot = await firestore
        .collection('Utente')
        .where('email', isEqualTo: user.email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      setState(() {
        _nomeController.text = data['nome'] ?? '';
        _cognomeController.text = data['cognome'] ?? '';
        _emailController.text = data['email'] ?? '';
        _dataController.text = data['dataNascita'] ?? '';
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _dataController.text =
        '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifica Profilo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.account_circle, size: 100),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _cognomeController,
              decoration: const InputDecoration(labelText: 'Cognome'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              enabled: false,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _dataController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Data di nascita',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: _pickDate,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Annulla'),
                ),
                /*ElevatedButton.icon(
                  onPressed: /*aggiorna profilo */{},
                  icon: const Icon(Icons.save),
                  label: const Text('Salva'),
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
