import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/percorso.dart';

class RicercaViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _searchQuery = '';
  List<Percorso> _allPercorsi = [];
  List<Percorso> _filteredResults = [];

  List<Percorso> get filteredResults => _filteredResults;
  String get searchQuery => _searchQuery;

  RicercaViewModel() {
    _caricaPercorsi();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filtraPercorsi();
  }

  Future<void> _caricaPercorsi() async {
    try {
      final snapshot = await _firestore.collection('Percorso').get();
      _allPercorsi = snapshot.docs.map((doc) {
        final data = doc.data();
        return Percorso(
          id: data['id'] ?? doc.id,
          nome: data['nome'] ?? '',
          autore: data['autore'] ?? '',
          recensione: (data['recensione'] ?? 0).toDouble(),
          durata: (data['durata'] ?? 0).toInt(),
        );
      }).toList();

      _filtraPercorsi();
    } catch (e) {
      if (kDebugMode) print("Errore caricamento percorsi: $e");
    }
  }

  void _filtraPercorsi() {
    final queryLower = _searchQuery.toLowerCase();
    _filteredResults = _allPercorsi
        .where((p) => p.nome.toLowerCase().contains(queryLower))
        .toList();

    notifyListeners();
  }
}
