import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- Placeholder LoginScreen ---
// Questo widget andrebbe in ui/view/Login.dart, ma lo teniamo qui per far funzionare l'app di prova
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // La logica di reindirizzamento verrà gestita dal tuo AppNavigation o wrapper di autenticazione.
    // Qui mostriamo solo il placeholder.

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Schermata Login (Placeholder)')),
    );
  }
}

// --- Placeholder HomeScreen ---
// Questo widget andrebbe in ui/view/Home.dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Schermata Home (Placeholder)')),
    );
  }
}

// --- App principale con le rotte ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StepOnTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      initialRoute: '/login', // Assicurati di partire dal login
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        // Qui andrebbero le altre rotte come '/register', '/percorsi', ecc.
      },
    );
  }
}

// --- Nuovo Widget per gestire l'inizializzazione e gli errori ---
class FirebaseInitializationWrapper extends StatelessWidget {
  // Inizializza Firebase al momento della creazione del FutureBuilder
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  FirebaseInitializationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Passa il Future di inizializzazione
      future: _initialization,
      builder: (context, snapshot) {
        // 1. Controlla gli errori
        if (snapshot.hasError) {
          // Se l'inizializzazione fallisce, mostra una schermata di errore
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text("Errore Firebase: ${snapshot.error}", textDirection: TextDirection.ltr),
              ),
            ),
          );
        }

        // 2. Connessione completata
        if (snapshot.connectionState == ConnectionState.done) {
          // Firebase è pronto, avviamo l'app principale
          return const MyApp();
        }

        // 3. Inizializzazione in corso (Mostra la F blu in modo elegante)
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text("Caricamento Firebase...", textDirection: TextDirection.ltr),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- Funzione main() semplificata ---
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Esegue il wrapper che gestirà l'inizializzazione
  runApp(FirebaseInitializationWrapper());
}
