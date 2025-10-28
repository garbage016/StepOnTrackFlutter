import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/RicercaViewModel.dart';
import '../../models/percorso.dart';
import 'SOSButton.dart';
import 'MyTopAppBar.dart';
import 'MyBottomNavigationBar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RicercaViewModel(),
      child: const _SearchScreenBody(),
    );
  }
}

class _SearchScreenBody extends StatefulWidget {
  const _SearchScreenBody();

  @override
  State<_SearchScreenBody> createState() => _SearchScreenBodyState();
}

class _SearchScreenBodyState extends State<_SearchScreenBody> {
  int currentIndex = 1;

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
    final viewModel = context.watch<RicercaViewModel>();
    final results = viewModel.filteredResults;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return false;
      },
      child: Scaffold(
        appBar: const MyTopBar(title: "Percorsi"),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Cerca Percorso...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: viewModel.searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => viewModel.updateSearchQuery(''),
                      )
                          : null,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: viewModel.updateSearchQuery,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final percorso = results[index];
                        return Card(
                          child: ListTile(
                            title: Text(percorso.nome),
                            subtitle: Text('Autore: ${percorso.autore}'),
                            onTap: () {
                              Navigator.pushNamed(context,'/dettaglio/${percorso.id}', // passiamo l'id del percorso
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              bottom: 20,
              right: 20,
              child: SosButton(size: 65),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onTap(2),
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
