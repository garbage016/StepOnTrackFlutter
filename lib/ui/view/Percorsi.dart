import 'package:flutter/material.dart';
import 'package:stepontrackflutter/ui/view/MyTopAppBar.dart';
import 'package:stepontrackflutter/ui/view/MyBottomNavigationBar.dart';
import 'SOSButton.dart';

class Percorso {
  final String id;
  final String nome;
  Percorso({required this.id, required this.nome});
}

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

class SearchScreen extends StatefulWidget {
  final List<Percorso> percorsi;

  const SearchScreen({super.key, required this.percorsi});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  int currentIndex = 1; // Percorsi

  void _onTap(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/percorsi');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/classifiche');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profilo');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = widget.percorsi
        .where((p) => p.nome.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return WillPopScope(
      onWillPop: () async {
        // Se vuoi tornare alla Home invece di uscire dall'app:
        Navigator.pushReplacementNamed(context, '/home');
        return false; // blocca uscita dall'app
      },
      child: Scaffold(
        appBar: const MyTopBar(title: "Percorsi"),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
            const Positioned(
              bottom: 20,
              right: 20,
              child: SosButton(size: 65),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () => _onTap(2), // apri classifiche
          backgroundColor: Colors.yellow[700],
          child: const Icon(Icons.add, size: 35),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onTap,
          onFabTap: () => _onTap(2),
        ),
      ),
    );
  }
}
