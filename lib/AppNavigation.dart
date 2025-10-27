import 'package:flutter/material.dart';
import 'ui/view/Login.dart';
import 'ui/view/Register.dart';
import 'ui/view/Home.dart';
import 'ui/view/Percorsi.dart';
import 'ui/view/Classifiche.dart';
import 'ui/view/Crea.dart';
import 'ui/view/mappa/Mappa.dart';
import 'ui/view/Utente.dart';
import 'ui/view/DettaglioPercorso.dart';
import 'ui/view/ModificaProfilo.dart';
import 'ui/view/mappa/MappaSeguiPercorso.dart';

class AppNavigation extends StatelessWidget {
  const AppNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(onRegisterClick: () {  }, onLoginSuccess: () {  },),
        '/register': (context) => RegistrationScreen(onBackClick: () {  }, onRegisterSuccess: () {  },),
        '/home': (context) => HomeScreen(),
        '/percorsi': (context) => SearchScreen(percorsi: [],),
        '/profilo': (context) => GestioneProfiloScreen(),
        '/classifiche': (context) => ClassificheScreen(),
        '/creaPercorso': (context) => CreaPercorsoScreen(),
        '/modificaProfilo': (context) => ModificaProfiloScreen(),
        // Rotte con parametri devono usare onGenerateRoute
      },
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '');
        if (uri.pathSegments.isEmpty) return null;

        switch (uri.pathSegments[0]) {
          case 'mappa':
            final id = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
            return MaterialPageRoute(
              builder: (context) => MappaScreen(),
            );

          /*case 'riepilogo':
            final nome = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
            final distanza = uri.pathSegments.length > 2 ? uri.pathSegments[2] : '';
            final durata = uri.pathSegments.length > 3 ? uri.pathSegments[3] : '';
            return MaterialPageRoute(
              builder: (context) => RiepilogoScreen(nome: nome, distanza: distanza, durata: durata),
            );*/

          case 'dettaglio':
            final id = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
            return MaterialPageRoute(
              builder: (context) => DettaglioPercorsoScreen(percorsoId: id),
            );

          /*case 'mappaSvolgimento':
            final id = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
            return MaterialPageRoute(
              builder: (context) => MappaSeguiPercorsoScreen(percorsoId: id),
            );*/

          default:
            return null;
        }
      },
    );
  }
}
