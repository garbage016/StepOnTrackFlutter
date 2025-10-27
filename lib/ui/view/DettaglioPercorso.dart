import 'package:flutter/material.dart';

class DettaglioPercorsoScreen extends StatefulWidget {
  final String percorsoId;

  const DettaglioPercorsoScreen({Key? key, required this.percorsoId}) : super(key: key);

  @override
  _DettaglioPercorsoScreenState createState() => _DettaglioPercorsoScreenState();
}

class _DettaglioPercorsoScreenState extends State<DettaglioPercorsoScreen> {
  int rating = 0;

  // TODO: sostituire con la chiamata al db e ViewModel
  Map<String, String> percorso = {
    "nome": "Percorso di prova",
    "autore": "Mario Rossi",
    "descrizione": "Un bellissimo percorso tra colline e natura.",
    "abiti": "Comodi, scarpe da trekking",
    "mezzo": "A piedi",
    "citta": "Firenze",
    "floraFauna": "Boschi e uccelli",
    "dataCreazione": "01/01/2024",
    "dislivello": "300",
    "distanzaKm": "10",
    "durataMinuti": "120",
  };

  double valutazioneMedia = 4.2; // TODO: sostituire con la media del db

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dettagli Percorso"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Info Percorso
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(percorso["nome"]!, style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 6),
                  Text("Autore: ${percorso["autore"]}"),
                  SizedBox(height: 6),
                  Text(percorso["descrizione"]!),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Dettagli tecnici
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  detailRow("Abiti consigliati", percorso["abiti"]!),
                  detailRow("Mezzo consigliato", percorso["mezzo"]!),
                  detailRow("Città", percorso["citta"]!),
                  detailRow("Flora e Fauna", percorso["floraFauna"]!),
                  detailRow("Data creazione", percorso["dataCreazione"]!),
                  detailRow("Dislivello", "${percorso["dislivello"]} m"),
                  detailRow("Distanza", "${percorso["distanzaKm"]} Km"),
                  detailRow("Durata", "${percorso["durataMinuti"]} min"),
                  detailRow("Media valutazioni", valutazioneMedia.toString()),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Recensione
          Text("Lascia una recensione", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              int starNumber = index + 1;
              return IconButton(
                icon: Icon(
                  starNumber <= rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                ),
                onPressed: () => setState(() {
                  rating = starNumber;
                }),
              );
            }),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: invia recensione al db
                  print("Recensione inviata: $rating stelle");
                },
                icon: Icon(Icons.send),
                label: Text("Invia"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Divider(thickness: 1, color: Colors.grey),
          SizedBox(height: 24),

          // Bottone ripercorri percorso
          ElevatedButton.icon(
            onPressed: () {
              // TODO: naviga alla mappa
              print("Naviga a mappaSvolgimento/${widget.percorsoId}");
            },
            icon: Icon(Icons.map),
            label: Text("Ripercorri l'itinerario su mappa"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700],
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
