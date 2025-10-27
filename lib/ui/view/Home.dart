import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Gradiente per il luogo del giorno
    final gradientText = LinearGradient(
      colors: [Colors.orange, Colors.yellow, Colors.green],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("StepOnTrack"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 10),
              Text(
                "Bentrovato Marco!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 30),

              // Meteo
              const Text(
                "Controlla subito com'è il tempo nella tua zona!",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: PageView(
                  children: [
                    Image.asset("assets/weather_sunny.png", fit: BoxFit.cover),
                    Image.asset("assets/weather_rainy.png", fit: BoxFit.cover),
                    Image.asset("assets/weather_cloudy.png", fit: BoxFit.cover),
                    Image.asset("assets/weather_snow.png", fit: BoxFit.cover),
                    Image.asset("assets/weather_windy.png", fit: BoxFit.cover),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse("https://www.3bmeteo.com");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Vai su 3B Meteo", style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 25),

              // Luogo del giorno
              const Text(
                "Il luogo del giorno è...",
                style: TextStyle(fontSize: 18),
              ),
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
              Image.asset(
                "assets/sirolo.png",
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Vai ai percorsi", style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 25),

              // Classifiche
              const Text(
                "I percorsi che trovi ti annoiano?",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                "Controlla subito chi si trova in vetta alle classifiche!",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Image.asset(
                "assets/paesaggi.png",
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Vai alle classifiche", style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 25),
            ],
          ),

          // Bottone SOS in basso a destra
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.red,
              child: const Icon(Icons.warning),
            ),
          ),
        ],
      ),
    );
  }
}
