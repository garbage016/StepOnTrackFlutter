import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/percorso.dart';

class ClassificheViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore;

  List<Percorso> _tuttiPercorsi = [];
  List<Percorso> get tuttiPercorsi => _tuttiPercorsi;

  ClassificheViewModel({FirebaseFirestore? firestoreInstance})
      : firestore = firestoreInstance ?? FirebaseFirestore.instance {
    caricaPercorsi();
  }

  Future<void> caricaPercorsi() async {
    try {
      final querySnapshot = await firestore.collection('Percorso').get();
      _tuttiPercorsi = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Percorso(
          id: doc.id,
          nome: data['nome'] ?? '',
          autore: data['autore'] ?? '',
          recensione: (data['recensione'] ?? 0).toDouble(),
          durata: (data['durata'] ?? 0).toInt(),
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Errore caricamento percorsi: $e');
    }
  }
}
