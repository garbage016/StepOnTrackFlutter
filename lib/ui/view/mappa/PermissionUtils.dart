import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Widget che gestisce permessi, GPS e posizione
class RichiestaPosizione extends StatefulWidget {
  final Function(Position?) onLocationReady;

  const RichiestaPosizione({super.key, required this.onLocationReady});

  @override
  State<RichiestaPosizione> createState() => _RichiestaPosizioneState();
}

class _RichiestaPosizioneState extends State<RichiestaPosizione> {
  bool _showDialog = false;
  bool _permessoConcesso = false;
  bool _gpsAttivo = false;
  Position? _posizione;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndGps();
  }

  Future<void> _checkPermissionsAndGps() async {
    // Controllo permessi
    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      setState(() => _showDialog = true);
    } else {
      _permessoConcesso = true;
      await _checkGps();
    }
  }

  Future<void> _checkGps() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Mostra dialog per attivare GPS
      bool gpsTurnedOn = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Attiva GPS'),
          content: const Text(
              'Per usare la mappa, attiva il GPS nelle impostazioni.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Ok')),
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annulla')),
          ],
        ),
      ) ??
          false;

      if (!gpsTurnedOn) return;
    }
    _gpsAttivo = true;
    _getPosition();
  }

  Future<void> _getPosition() async {
    try {
      _posizione = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      widget.onLocationReady(_posizione);
    } catch (e) {
      debugPrint('Errore nel recupero posizione: $e');
      widget.onLocationReady(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showDialog) {
      return AlertDialog(
        title: const Text("Autorizzazione posizione"),
        content: const Text(
            "Per usare la mappa è necessario consentire l'accesso alla posizione e attivare il GPS."),
        actions: [
          TextButton(
              onPressed: () async {
                PermissionStatus status = await Permission.location.request();
                if (status.isGranted) {
                  _permessoConcesso = true;
                  await _checkGps();
                }
                setState(() => _showDialog = false);
              },
              child: const Text("Consenti")),
          TextButton(
              onPressed: () {
                setState(() => _showDialog = false);
                Navigator.pop(context); // torna indietro
              },
              child: const Text("Annulla")),
        ],
      );
    }
    return const SizedBox.shrink(); // Placeholder
  }
}
