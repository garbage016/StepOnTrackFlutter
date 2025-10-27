import 'package:flutter/material.dart';

class CreaPercorsoScreen extends StatefulWidget {
  const CreaPercorsoScreen({Key? key}) : super(key: key);

  @override
  State<CreaPercorsoScreen> createState() => _CreaPercorsoScreenState();
}

class _CreaPercorsoScreenState extends State<CreaPercorsoScreen> {
  // Campi
  final _nomeController = TextEditingController();
  final _descrizioneController = TextEditingController();
  final _abitiController = TextEditingController();
  final _distanzaController = TextEditingController();
  final _dislivelloController = TextEditingController();
  final _floraFaunaController = TextEditingController();
  final _cittaController = TextEditingController();

  String _mezzoSelezionato = '';
  List<String> mezzi = ['A piedi', 'In bici', 'In moto'];
  List<String> suggerimentiCitta = [];

  bool mostraErrori = false;
  bool isCittaMenuExpanded = false;
  bool isMezzoMenuExpanded = false;

  // Funzione placeholder per filtraComuniDaFile
  List<String> filtraComuniDaFile(String query) {
    if (query.isEmpty) return [];
    // Qui puoi aggiungere una lista statica di città o leggere un file
    List<String> comuni = ['Roma', 'Milano', 'Napoli', 'Torino', 'Firenze'];
    return comuni.where((c) => c.toLowerCase().contains(query.toLowerCase())).take(30).toList();
  }

  @override
  Widget build(BuildContext context) {
    final coloriError = mostraErrori ? Colors.red : Colors.grey;

    return Scaffold(
      appBar: AppBar(title: const Text("Crea Percorso")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- Nome ---
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: "Nome percorso",
                border: const OutlineInputBorder(),
                errorText: mostraErrori && _nomeController.text.isEmpty ? "Campo obbligatorio" : null,
              ),
            ),
            const SizedBox(height: 16),

            // --- Città con Autocompletamento ---
            TextField(
              controller: _cittaController,
              decoration: InputDecoration(
                labelText: "Città",
                border: const OutlineInputBorder(),
                errorText: mostraErrori && _cittaController.text.isEmpty ? "Campo obbligatorio" : null,
              ),
              onChanged: (value) {
                setState(() {
                  suggerimentiCitta = filtraComuniDaFile(value);
                  isCittaMenuExpanded = true;
                });
              },
            ),
            if (isCittaMenuExpanded && suggerimentiCitta.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: suggerimentiCitta.map((c) {
                    return ListTile(
                      title: Text(c),
                      onTap: () {
                        setState(() {
                          _cittaController.text = c;
                          isCittaMenuExpanded = false;
                          suggerimentiCitta = [];
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),

            // --- Descrizione ---
            TextField(
              controller: _descrizioneController,
              decoration: const InputDecoration(
                labelText: "Descrizione",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // --- Abiti ---
            TextField(
              controller: _abitiController,
              decoration: const InputDecoration(
                labelText: "Abiti suggeriti",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // --- Distanza ---
            TextField(
              controller: _distanzaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Distanza (km)",
                border: const OutlineInputBorder(),
                errorText: mostraErrori && _distanzaController.text.isEmpty ? "Campo obbligatorio" : null,
              ),
            ),
            const SizedBox(height: 16),

            // --- Dislivello ---
            TextField(
              controller: _dislivelloController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Dislivello (m)",
                border: const OutlineInputBorder(),
                errorText: mostraErrori && _dislivelloController.text.isEmpty ? "Campo obbligatorio" : null,
              ),
            ),
            const SizedBox(height: 16),

            // --- Flora e Fauna ---
            TextField(
              controller: _floraFaunaController,
              decoration: const InputDecoration(
                labelText: "Flora e Fauna",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // --- Mezzo ---
            DropdownButtonFormField<String>(
              value: _mezzoSelezionato.isEmpty ? null : _mezzoSelezionato,
              decoration: InputDecoration(
                labelText: "Mezzo",
                border: const OutlineInputBorder(),
                errorText: mostraErrori && _mezzoSelezionato.isEmpty ? "Campo obbligatorio" : null,
              ),
              items: mezzi.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (value) {
                setState(() {
                  _mezzoSelezionato = value ?? '';
                });
              },
            ),
            const SizedBox(height: 40),

            // --- Bottoni ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Azione annulla
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("Annulla"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red[200]),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      mostraErrori = true;
                    });

                    final campiValidi = _nomeController.text.isNotEmpty &&
                        _cittaController.text.isNotEmpty &&
                        _mezzoSelezionato.isNotEmpty &&
                        double.tryParse(_distanzaController.text) != null &&
                        int.tryParse(_dislivelloController.text) != null;

                    if (!campiValidi) return;

                    // TODO: Qui il ViewModel per salvare i dati
                    // Navigator.pushNamed(context, "/mappa", arguments: percorsoId);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Avanti"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[300]),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
