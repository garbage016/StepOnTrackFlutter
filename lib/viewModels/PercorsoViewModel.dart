import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/percorso.dart';

class PercorsoViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore;
  final String? userEmail;

  PercorsoViewModel({FirebaseFirestore? firestoreInstance, this.userEmail})
      : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  List<Percorso> _percorsiPiuRecensiti = [];
  List<Percorso> get percorsiPiuRecensiti => _percorsiPiuRecensiti;

  List<String> _percorsiPreferiti = [];
  List<String> get percorsiPreferiti => _percorsiPreferiti;

  List<Percorso> _listaPercorsiPreferiti = [];
  List<Percorso> get listaPercorsiPreferiti => _listaPercorsiPreferiti;

  Map<String, int> numeroRecensioniMappa = {};

  Percorso? percorsoDettaglio;
  double valutazioneMedia = 0.0;

  List<Percorso> mieiPercorsi = [];

  // Genera un nuovo percorsoID
  Future<int> generaPercorsoID() async {
    final snapshot = await firestore.collection('Percorso').get();
    final idMassimo = snapshot.docs
        .map((doc) => doc.get('percorsoID') as int?)
        .whereType<int>()
        .fold<int>(0, (prev, element) => element > prev ? element : prev);
    return idMassimo + 1;
  }

  // Recupera username dall'email
  Future<String?> getUsername(String email) async {
    final snapshot = await firestore
        .collection('Utente')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;
  }

  // Crea un nuovo percorso
  Future<void> creaPercorso({
    required int percorsoID,
    required String nome,
    required String descrizione,
    required String abiti,
    required int distanza,
    required int dislivello,
    required String floraFauna,
    required String citta,
    required String mezzo,
    required String autore,
  }) async {
    final percorso = {
      'percorsoID': percorsoID,
      'nome': nome,
      'descrizione': descrizione,
      'abiti': abiti,
      'distanza': distanza,
      'dislivello': dislivello,
      'floraFauna': floraFauna,
      'citta': citta,
      'mezzo': mezzo,
      'durata': null,
      'autore': autore,
      'timestampCreazione': Timestamp.now(),
      'coordinate': [],
    };
    await firestore.collection('Percorso').doc(percorsoID.toString()).set(percorso);
  }

  // Elimina un percorso
  Future<void> eliminaPercorso(String percorsoId) async {
    await firestore.collection('Percorso').doc(percorsoId).delete();
  }

  // Carica dettaglio percorso
  Future<void> caricaDettaglioPercorso(String id) async {
    final doc = await firestore.collection('Percorso').doc(id).get();
    if (!doc.exists) return;
    percorsoDettaglio = Percorso.fromMap(doc.data()!..['id'] = doc.id);
  }

  // Carica valutazioni e calcola media
  Future<void> caricaValutazioni(String percorsoId) async {
    final snapshot = await firestore
        .collection('Recensione')
        .where('percorsoId', isEqualTo: percorsoId)
        .get();
    final voti = snapshot.docs
        .map((d) => d.get('valutazione') as int?)
        .whereType<int>()
        .toList();
    valutazioneMedia = voti.isNotEmpty ? voti.reduce((a, b) => a + b) / voti.length : 0.0;
    await firestore.collection('Percorso').doc(percorsoId).update({'recensione': valutazioneMedia});
  }

  // Invia recensione
  Future<void> inviaRecensione({
    required String percorsoId,
    required int valutazione,
    required String autore,
  }) async {
    final snapshot = await firestore
        .collection('Recensione')
        .orderBy('id', descending: true)
        .limit(1)
        .get();
    final ultimoId = snapshot.docs.firstOrNull?.get('id') as int? ?? 0;
    final nuovoId = ultimoId + 1;
    await firestore.collection('Recensione').add({
      'id': nuovoId,
      'autore': autore,
      'valutazione': valutazione,
      'percorsoId': percorsoId,
      'timestamp': Timestamp.now(),
    });
    await caricaValutazioni(percorsoId);
  }

  // Carica percorsi più recensiti
  Future<void> caricaPercorsiPiuRecensiti() async {
    final snapshot = await firestore.collection('Percorso').get();
    final percorsiList = snapshot.docs.map((doc) {
      final data = doc.data();
      return Percorso.fromMap(data..['id'] = doc.id);
    }).toList();

    for (var percorso in percorsiList) {
      final recensioniSnapshot = await firestore
          .collection('Recensione')
          .where('percorsoId', isEqualTo: percorso.id)
          .get();
      numeroRecensioniMappa[percorso.id] = recensioniSnapshot.size;
    }

    percorsiList.sort((a, b) =>
        (numeroRecensioniMappa[b.id] ?? 0).compareTo(numeroRecensioniMappa[a.id] ?? 0));

    _percorsiPiuRecensiti = percorsiList;
    notifyListeners();
  }

  // Gestione preferiti
  Future<void> caricaPercorsiPreferiti() async {
    if (userEmail == null) return;
    final snapshot = await firestore
        .collection('Preferiti')
        .where('utenteEmail', isEqualTo: userEmail)
        .get();
    _percorsiPreferiti = snapshot.docs.map((d) => d.get('percorsoId') as String).toList();
    await caricaInfoPercorsiPreferiti(_percorsiPreferiti);
  }

  Future<void> caricaInfoPercorsiPreferiti(List<String> percorsiIds) async {
    _listaPercorsiPreferiti.clear();
    for (var id in percorsiIds) {
      final doc = await firestore.collection('Percorso').doc(id).get();
      if (doc.exists) {
        _listaPercorsiPreferiti.add(Percorso.fromMap(doc.data()!..['id'] = doc.id));
      }
    }
    notifyListeners();
  }

  Future<void> togglePreferito(String percorsoId) async {
    if (userEmail == null) return;
    final collezione = firestore.collection('Preferiti');
    if (_percorsiPreferiti.contains(percorsoId)) {
      final snapshot = await collezione
          .where('utenteEmail', isEqualTo: userEmail)
          .where('percorsoId', isEqualTo: percorsoId)
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      _percorsiPreferiti.remove(percorsoId);
    } else {
      await collezione.add({'utenteEmail': userEmail, 'percorsoId': percorsoId});
      _percorsiPreferiti.add(percorsoId);
    }
    notifyListeners();
  }
}
