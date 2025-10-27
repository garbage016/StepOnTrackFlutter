import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class Percorso {
  final String id;
  final String nome;
  Percorso({required this.id, required this.nome});
}

// Widget che rappresenta la card di un percorso
class PercorsoCard extends StatelessWidget {
  final Percorso percorso;
  final VoidCallback onTap;

  const PercorsoCard({super.key, required this.percorso, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(percorso.nome),
        onTap: onTap,
      ),
    );
  }
}

// Bottone SOS
class SosButton extends StatelessWidget {
  const SosButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Logica SOS
      },
      backgroundColor: Colors.red,
      child: const Icon(Icons.warning),
    );
  }
}

class SearchScreen extends StatefulWidget {
  final List<Percorso> percorsi;

  const SearchScreen({super.key, required this.percorsi});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    // Filtra i percorsi in base alla query
    final filteredResults = widget.percorsi
        .where((p) => p.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cerca Percorso"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra di ricerca
            TextField(
              decoration: InputDecoration(
                labelText: "Cerca Percorso...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      query = '';
                    });
                  },
                )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Lista dei percorsi filtrati
            Expanded(
              child: ListView.separated(
                itemCount: filteredResults.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final percorso = filteredResults[index];
                  return PercorsoCard(
                    percorso: percorso,
                    onTap: () {
                      // Logica navigazione verso dettagli percorso
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottone SOS in basso a destra
      floatingActionButton: const SosButton(),
    );
  }
}
