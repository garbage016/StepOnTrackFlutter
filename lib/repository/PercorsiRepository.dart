import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stepontrackflutter/models/percorso.dart';



class PercorsiRepository {
  final CollectionReference _collection;

  PercorsiRepository({FirebaseFirestore? firestore})
      : _collection = (firestore ?? FirebaseFirestore.instance).collection('Percorso');

  Future<List<Percorso>> getTuttiIPercorsi() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => Percorso.fromMap(doc.data() as Map<String, dynamic>).copyWith(id: doc.id))
        .toList();
  }

  Future<void> aggiungiPercorso(Percorso percorso) async {
    final docRef = _collection.doc();
    final percorsoConId = percorso.copyWith(id: docRef.id);
    await docRef.set(percorsoConId.toMap());
  }

  Future<void> eliminaPercorso(String id) async {
    await _collection.doc(id).delete();
  }
}
