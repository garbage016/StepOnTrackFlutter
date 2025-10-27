import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Recupera l'ultima posizione nota oppure richiede una nuova posizione
Future<Position?> getLastKnownLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Controlla se il GPS è attivo
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    debugPrint('Servizio di localizzazione non attivo');
    return null;
  }

  // Controlla i permessi
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      debugPrint('Permesso posizione negato');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    debugPrint('Permesso posizione negato permanentemente');
    return null;
  }

  try {
    // Prova a prendere l'ultima posizione nota
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      debugPrint('Ultima posizione: ${lastPosition.latitude}, ${lastPosition.longitude}');
      return lastPosition;
    }

    // Se non c'è ultima posizione, richiedi una nuova posizione precisa
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 1),
    );
    return currentPosition;
  } catch (e) {
    debugPrint('Errore nel recupero posizione: $e');
    return null;
  }
}
