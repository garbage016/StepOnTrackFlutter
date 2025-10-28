import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stepontrackflutter/ui/view/MyTopAppBar.dart';
import 'package:stepontrackflutter/ui/view/MyBottomNavigationBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'Crea.dart';
import 'SOSButton.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final query = await FirebaseFirestore.instance
          .collection('Utente')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          username = query.docs.first['username'] ?? "SenzaNome";
        });
      } else {
        setState(() {
          username = "UtenteErr1"; // Nessun documento trovato
        });
      }
    } catch (e) {
      print("Errore recupero username: $e");
      setState(() {
        username = "Utente"; // Errore generico
      });
    }
}


  void _onTap(int index) {
    if (index == currentIndex) return;

    setState(() => currentIndex = index);

    switch (index) {
      case 0:
      // Nessun Navigator, siamo già in home
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
    final gradientText = const LinearGradient(
      colors: [Colors.orange, Colors.yellow, Colors.green],
    );

    return WillPopScope(
      onWillPop: () async {
        // Da Home: se premi "indietro" chiudi l’app
        return true;
      },
      child: Scaffold(
        appBar: const MyTopBar(title: "StepOnTrack"),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 10),
                Text(
                  "Bentrovato ${username ?? 'Utente'}!",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 30),

                const Text("Controlla subito com'è il tempo nella tua zona!",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 180,
                  child: PageView(
                    children: [
                      Image.asset("assets/weather_sunny.jpg", fit: BoxFit.cover),
                      Image.asset("assets/weather_rainy.jpg", fit: BoxFit.cover),
                      Image.asset("assets/weather_cloudy.jpg", fit: BoxFit.cover),
                      Image.asset("assets/weather_snow.jpg", fit: BoxFit.cover),
                      Image.asset("assets/weather_windy.jpg", fit: BoxFit.cover),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final url = Uri.parse("https://www.3bmeteo.com");

                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication, //forza l’apertura nel browser
                      );
                    } else {
                      debugPrint("Impossibile aprire l’URL: $url");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Impossibile aprire il link.")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Vai su 3B Meteo",
                    style: TextStyle(color: Colors.black),
                  ),
                )
                ,
                const SizedBox(height: 25),

                const Text("Il luogo del giorno è...",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Sirolo",
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      foreground: Paint()
                        ..shader = gradientText.createShader(
                          const Rect.fromLTWH(0, 0, 200, 70),
                        ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Image.asset("assets/sirolo.jpg",
                    height: 200, fit: BoxFit.cover),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _onTap(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Vai ai percorsi",
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 25),

                const Text("I percorsi che trovi ti annoiano?",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                const Text("Controlla subito chi si trova in vetta alle classifiche!",
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 12),
                Image.asset("assets/paesaggi.png",
                    height: 200, fit: BoxFit.cover),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _onTap(2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Vai alle classifiche",
                      style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 25),
              ],
            ),

            // Bottone SOS in basso a destra
            Positioned(
              bottom: 20,
              right: 20,
              child: const SosButton(size: 65),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreaPercorsoScreen(),
                fullscreenDialog: true, // sembra una modale
              ),
            );
          },
          backgroundColor: Colors.yellow[700],
          child: const Icon(Icons.add, size: 35),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onTap,
          onFabTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreaPercorsoScreen(),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
