import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/Utente.dart'; // importa il tuo model

class ProfiloViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SharedPreferences? _prefs;

  Utente _utente = Utente();
  String _distanza = 'Km';
  bool _schermoAcceso = false;
  bool _notifiche = true;

  Utente get utente => _utente;
  String get distanza => _distanza;
  bool get schermoAcceso => _schermoAcceso;
  bool get notifiche => _notifiche;

  ProfiloViewModel() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadUserProfile();
    _loadPreferences();
  }

  Future<void> _loadUserProfile() async {
    final email = _auth.currentUser?.email;
    if (email == null) return;

    final query = await _firestore.collection('Utente').where('email', isEqualTo: email).get();
    if (query.docs.isNotEmpty) {
      _utente = Utente.fromMap(query.docs.first.data());
      notifyListeners();
    }
  }

  void _loadPreferences() {
    _distanza = _prefs?.getString('distance_unit') ?? 'Km';
    _schermoAcceso = _prefs?.getBool('screen_on') ?? false;
    _notifiche = _prefs?.getBool('notifications_enabled') ?? true;
    notifyListeners();
  }

  void aggiornaDistanza(String unita) {
    _distanza = unita;
    _prefs?.setString('distance_unit', unita);
    notifyListeners();
  }

  void aggiornaSchermo(bool stato) {
    _schermoAcceso = stato;
    _prefs?.setBool('screen_on', stato);
    notifyListeners();
  }

  void aggiornaNotifiche(bool attivo) {
    _notifiche = attivo;
    _prefs?.setBool('notifications_enabled', attivo);
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // Metodo per ricaricare manualmente i dati dell'utente dal Firestore
  Future<void> caricaDatiUtente() async {
    await _loadUserProfile();
  }
}
