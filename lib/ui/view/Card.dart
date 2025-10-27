import 'package:flutter/material.dart';
import 'package:stepontrackflutter/models/percorso.dart';
import 'package:stepontrackflutter/viewModels/PercorsoSvoltoViewModel.dart';
import '../../models/PercorsoSvolto.dart';
import '../../viewModels/PercorsoViewModel.dart';

/// ------------------ PERCORSO CARD ------------------
class PercorsoCard extends StatelessWidget {
  final Percorso percorso;
  final PercorsoViewModel viewModel;
  final VoidCallback onTap;

  const PercorsoCard({
    super.key,
    required this.percorso,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPreferito = viewModel.percorsiPreferiti.contains(percorso.id);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.terrain, size: 60, color: Colors.green),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(percorso.nome, style: Theme.of(context).textTheme.titleMedium),
                  Text("Recensione: ${percorso.recensione.toStringAsFixed(1)}"),
                  Text("Durata: ${percorso.durata} min"),
                ],
              ),
            ),
            IconButton(
              onPressed: () => viewModel.togglePreferito(percorso.id),
              icon: Icon(
                isPreferito ? Icons.bookmark : Icons.bookmark_border,
                color: isPreferito ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ STEP CARD ------------------
class StepCard extends StatelessWidget {
  final Percorso percorso;
  final PercorsoViewModel viewModel;
  final VoidCallback onTap;

  const StepCard({
    super.key,
    required this.percorso,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPreferito = viewModel.percorsiPreferiti.contains(percorso.id);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.terrain, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(percorso.nome, style: Theme.of(context).textTheme.bodyLarge),
                  if (percorso.durata != 0)
                    Text("Durata: ${percorso.durata} min", style: Theme.of(context).textTheme.bodySmall),
                  if (percorso.recensione != 0.0)
                    Text("Recensione: ${percorso.recensione.toStringAsFixed(1)}", style: Theme.of(context).textTheme.bodySmall)
                  else
                    Text("Nessuna recensione", style: Theme.of(context).textTheme.bodySmall),
                  if (percorso.timestampCreazione != null)
                    Text(
                      "Data: ${percorso.timestampCreazione!.toDate().toLocal()}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => viewModel.togglePreferito(percorso.id),
              icon: Icon(
                isPreferito ? Icons.bookmark : Icons.bookmark_border,
                color: isPreferito ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ PERCORSO SVOLTO CARD ------------------
class PercorsoSvoltoCard extends StatelessWidget {
  final PercorsoSvolto percorsoSvolto;
  final PercorsoViewModel viewModel;
  final VoidCallback onTap;

  const PercorsoSvoltoCard({
    super.key,
    required this.percorsoSvolto,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPreferito = viewModel.percorsiPreferiti.contains(percorsoSvolto.idPercorso);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(Icons.terrain, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(percorsoSvolto.nomePercorso, style: Theme.of(context).textTheme.bodyLarge),
                  Text("Tempo impiegato: ${percorsoSvolto.tempoImpiegato} min", style: Theme.of(context).textTheme.bodySmall),
                  Text("Data: ${percorsoSvolto.dataSvolgimento}", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                ],
              ),
            ),
            IconButton(
              onPressed: () => viewModel.togglePreferito(percorsoSvolto.idPercorso),
              icon: Icon(
                isPreferito ? Icons.bookmark : Icons.bookmark_border,
                color: isPreferito ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------ CLASSIFICA CARD ------------------
class ClassificaCard extends StatelessWidget {
  final String titolo;
  final IconData icon;
  final List<Percorso> percorsi;

  const ClassificaCard({
    super.key,
    required this.titolo,
    required this.icon,
    required this.percorsi,
  });

  @override
  Widget build(BuildContext context) {
    final coloriAccento = [Colors.amber, Colors.grey, Colors.brown];
    final coloriSfondo = [Colors.amber.shade100, Colors.grey.shade300, Colors.brown.shade200];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 8),
            Text(titolo, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 8),
        ...percorsi.take(3).toList().asMap().entries.map((entry) {
          final index = entry.key;
          final percorso = entry.value;
          final coloreAccento = coloriAccento[index];
          final coloreSfondo = coloriSfondo[index];
          final posizione = ["1°", "2°", "3°"][index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: 85,
              decoration: BoxDecoration(
                color: coloreSfondo,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(width: 6, height: 50, color: coloreAccento),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(posizione, style: TextStyle(color: coloreAccento)),
                            const SizedBox(width: 6),
                            Text(percorso.nome, style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        Text("Recensione: ${percorso.recensione}", style: Theme.of(context).textTheme.bodySmall),
                        Text("Durata: ${percorso.durata} min", style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

/// ------------------ PERCORSO PREFERITO CARD ------------------
class PercorsoPreferitoCard extends StatelessWidget {
  final Percorso percorso;
  final PercorsoViewModel viewModel;
  final VoidCallback onTap;

  const PercorsoPreferitoCard({
    super.key,
    required this.percorso,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPreferito = viewModel.percorsiPreferiti.contains(percorso.id);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.terrain, size: 60, color: Colors.green),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(percorso.nome, style: Theme.of(context).textTheme.titleMedium),
                  Text("Recensione: ${percorso.recensione.toStringAsFixed(1)}"),
                  Text("Durata: ${percorso.durata} min"),
                ],
              ),
            ),
            IconButton(
              onPressed: () => viewModel.togglePreferito(percorso.id),
              icon: Icon(
                isPreferito ? Icons.bookmark : Icons.bookmark_border,
                color: isPreferito ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
