import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/percorso.dart';
import '../../ui/view/MyTopAppBar.dart';
import '../../ui/view/SOSButton.dart';
import '../../ui/view/MyBottomNavigationBar.dart';
import '../../ui/theme/Color.dart';

class DettaglioPercorsoScreen extends StatefulWidget {
  final String percorsoId;

  const DettaglioPercorsoScreen({super.key, required this.percorsoId});

  @override
  State<DettaglioPercorsoScreen> createState() => _DettaglioPercorsoScreenState();
}

class _DettaglioPercorsoScreenState extends State<DettaglioPercorsoScreen> {
  Percorso? percorso;
  double valutazioneMedia = 0.0;
  int rating = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _caricaDettaglioPercorso();
    _caricaValutazioni();
  }

  Future<void> _caricaDettaglioPercorso() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Percorso')
          .doc(widget.percorsoId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          percorso = Percorso(
            id: widget.percorsoId,
            nome: data['nome'] ?? '',
            autore: data['autore'] ?? '',
            descrizione: data['descrizione'] ?? '',
            abiti: data['abiti'] ?? '',
            mezzo: data['mezzo'] ?? '',
            citta: data['citta'] ?? '',
            floraFauna: data['floraFauna'] ?? '',
            dislivello: (data['dislivello'] ?? 0).toInt(),
            distanza: (data['distanza'] ?? 0).toInt(),
            durata: (data['durata'] ?? 0).toInt()
          );
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Errore caricamento percorso: $e');
    }
  }

  Future<void> _caricaValutazioni() async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('Recensione')
          .where('percorsoId', isEqualTo: widget.percorsoId)
          .get();

      final voti = result.docs
          .map((d) => (d['valutazione'] as num?)?.toInt())
          .whereType<int>()
          .toList();

      setState(() {
        valutazioneMedia = voti.isNotEmpty ? voti.reduce((a, b) => a + b) / voti.length : 0.0;
      });
    } catch (e) {
      debugPrint('Errore caricamento valutazioni: $e');
    }
  }

  Future<void> _inviaRecensione() async {
    if (rating == 0) return;

    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'anonimo';
    final recensioni = FirebaseFirestore.instance.collection('Recensione');

    final ultimo = await recensioni.orderBy('id', descending: true).limit(1).get();
    final nuovoId = (ultimo.docs.isNotEmpty ? ultimo.docs.first['id'] as int : 0) + 1;

    await recensioni.add({
      'id': nuovoId,
      'autore': userEmail,
      'valutazione': rating,
      'percorsoId': widget.percorsoId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    _caricaValutazioni();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Recensione inviata!")),
    );
  }
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Data non disponibile';
    return DateFormat('dd/MM/yyyy').format(timestamp.toDate());
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading || percorso == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const MyTopBar(title: 'Dettagli Percorso'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(percorso!.nome, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('Autore: ${percorso!.autore}',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 8),
                    Text(percorso!.descrizione,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(formatTimestamp(percorso!.timestampCreazione)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _detailRow('Abiti consigliati', percorso!.abiti),
                    _detailRow('Mezzo consigliato', percorso!.mezzo),
                    _detailRow('Città', percorso!.citta),
                    _detailRow('Flora e Fauna', percorso!.floraFauna),
                    _detailRow('Data creazione', formatTimestamp(percorso!.timestampCreazione)),
                    _detailRow('Dislivello', '${percorso!.dislivello} m'),
                    _detailRow('Distanza', '${percorso!.distanza} Km'),
                    _detailRow('Durata', '${percorso!.durata} min'),
                    _detailRow('Media valutazioni', valutazioneMedia.toStringAsFixed(1)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Lascia una recensione',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (index) => IconButton(
                  iconSize: 40,
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => setState(() => rating = index + 1),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _inviaRecensione,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.send),
                label: const Text('Invia'),
              ),
            ),
            const Divider(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/mappaSvolgimento/${widget.percorsoId}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.map),
              label: const Text("Ripercorri l'itinerario su mappa"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
