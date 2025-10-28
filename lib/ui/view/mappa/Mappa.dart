import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MappaScreen extends StatefulWidget {
  const MappaScreen({super.key});

  @override
  _MappaScreenState createState() => _MappaScreenState();
}

class _MappaScreenState extends State<MappaScreen> {
  late MapController mapController;
  GeoPoint? posizioneCorrente;
  Timer? timer;
  Duration elapsedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    mapController = MapController( initPosition: GeoPoint(latitude: 45.4642, longitude: 9.1900),);
    _initLocation();
  }


  Future<void> _initLocation() async {
    // Aggiungo la richiesta di permesso (essenziale)
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Gestione semplificata del caso in cui l'utente nega il permesso
      print("I permessi di geolocalizzazione sono stati negati.");
      return;
    }

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      posizioneCorrente = GeoPoint(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
    });

    // Centra la mappa sulla posizione corrente solo se è disponibile
    if (posizioneCorrente != null) {
      await mapController.goToLocation(posizioneCorrente!);
    }
  }

  void _startTimer() {
    // Ho impostato il timer per iniziare in uno stato "Paused" (Pausa)
    // Sarà attivato dal pulsante 'Avvia'.
  }

  // Funzione fittizia per i pulsanti
  void _handleStartStop(String action) {
    if (action == 'Avvia' && (timer == null || !timer!.isActive)) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          elapsedTime += const Duration(seconds: 1);
        });
      });
    } else if (action == 'Sospendi' && timer != null && timer!.isActive) {
      timer!.cancel();
    } else if (action == 'STOP') {
      timer?.cancel();
      setState(() {
        elapsedTime = Duration.zero;
      });
    }
    // Forza la UI ad aggiornarsi
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    mapController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    bool isTracking = timer != null && timer!.isActive;

    return Scaffold(
      appBar: AppBar(
        title: const Text("StepOnTrack"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          // MAPPA: Usa il parametro osmOption
          posizioneCorrente != null
              ?OSMFlutter(
            controller: mapController,
            osmOption: OSMOption(
              userTrackingOption: const UserTrackingOption(
                enableTracking: true,  // centra la mappa sulla posizione dell'utente
                unFollowUser: false,
              ),
              showContributorBadgeForOSM: false,
            ),
          )
              : const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.blueAccent),
                SizedBox(height: 16),
                Text(
                  "Acquisizione posizione...",
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
              ],
            ),
          ),

          // OVERLAY DEL TIMER e Controlli
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Visualizzazione Durata
                  Text(
                    "Durata: ${_formatDuration(elapsedTime)}",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: isTracking ? Colors.green.shade700 : Colors.blueGrey.shade600,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pulsanti
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TrackingButton(
                        text: isTracking ? "Pausa" : "Avvia",
                        icon: isTracking ? Icons.pause : Icons.play_arrow,
                        color: isTracking ? Colors.orange : Colors.green,
                        onPressed: () => _handleStartStop(isTracking ? "Sospendi" : "Avvia"),
                        isEnabled: posizioneCorrente != null,
                      ),
                      _TrackingButton(
                        text: "STOP",
                        icon: Icons.stop,
                        color: Colors.red,
                        onPressed: () => _handleStartStop("STOP"),
                        isEnabled: elapsedTime > Duration.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Helper per i pulsanti (per una UI più pulita)
class _TrackingButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isEnabled;

  const _TrackingButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
        disabledBackgroundColor: color.withOpacity(0.4),
      ),
    );
  }
}
