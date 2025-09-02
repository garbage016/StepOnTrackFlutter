import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stepontrackflutter/models/utente.dart';

class UtenteRepository {
  final CollectionReference _utentiCollection =
  FirebaseFirestore.instance.collection('Utente');

  Future<void> salvaUtente(Utente utente) async {
    await _utentiCollection.doc(utente.username).set(utente.toMap());
  }

  Future<void> aggiornaUtente(String username, Map<String, dynamic> updates) async {
    await _utentiCollection.doc(username).update(updates);
  }
}
