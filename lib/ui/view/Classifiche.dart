import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepontrackflutter/viewModels/ClassificheViewModel.dart';
import 'package:stepontrackflutter/ui/view/Card.dart';
import 'package:stepontrackflutter/ui/view/MyBottomNavigationBar.dart';
import 'package:stepontrackflutter/ui/view/MyTopAppBar.dart';

class ClassificheScreen extends StatelessWidget {
  const ClassificheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ClassificheViewModel>();
    final percorsi = viewModel.tuttiPercorsi;

// Ordiniamo copie separate per non modificare la lista originale
    final miglioriRecensione = List.of(percorsi)
      ..sort((a, b) => (b.recensione ?? 0.0).compareTo(a.recensione ?? 0.0));

    final durataMinore = List.of(percorsi)
      ..sort((a, b) => (a.durata ?? 0).compareTo(b.durata ?? 0));

    final piuPopolari = List.of(percorsi)..shuffle();

    final avventura = List.of(percorsi)
      ..sort((a, b) => (b.durata ?? 0).compareTo(a.durata ?? 0));

    return Scaffold(
      appBar: MyTopBar(title: "Classifiche"),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: 0, // indice della scheda attiva
        onTap: (index) {
          // logica di navigazione quando si clicca una voce
          print("Hai cliccato $index");
        },
        onFabTap: () {
          // logica quando si clicca il FAB
          print("FAB cliccato");
        },
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClassificaCard(
              titolo: "Migliori per Recensione",
              icon: Icons.star,
              percorsi: miglioriRecensione.take(3).toList(),
            ),
            const SizedBox(height: 24),
            ClassificaCard(
              titolo: "Durata Minore",
              icon: Icons.timer,
              percorsi: durataMinore.take(3).toList(),
            ),
            const SizedBox(height: 24),
            ClassificaCard(
              titolo: "Più Popolari",
              icon: Icons.flag,
              percorsi: piuPopolari.take(3).toList(),
            ),
            const SizedBox(height: 24),
            ClassificaCard(
              titolo: "Avventura",
              icon: Icons.terrain,
              percorsi: avventura.take(3).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
