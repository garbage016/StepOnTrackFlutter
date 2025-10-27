import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MappaScreen extends StatefulWidget {
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
    mapController = MapController(
      initMapWithUserPosition: false, // disattivo init automatico
      initPosition: GeoPoint(latitude: 0, longitude: 0), // placeholder
    );
    _initLocation();
    _startTimer();
  }

  Future<void> _initLocation() async {
    Position? pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      posizioneCorrente = GeoPoint(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
    });

    // Centra la mappa sulla posizione corrente
    await mapController.changeLocation(posizioneCorrente!);
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        elapsedTime += Duration(seconds: 1);
      });
    });
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
    return Scaffold(
      body: Stack(
        children: [
          posizioneCorrente != null
              ? OSMFlutter(
      controller: mapController,
        trackMyPosition: true,
        showContributorBadgeForOSM: false,
      )
        : Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text("Acquisizione posizione..."),
            ],
          ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Text(
                  "Durata: ${_formatDuration(elapsedTime)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text("Avvia")),
                    ElevatedButton(onPressed: () {}, child: Text("Sospendi")),
                    ElevatedButton(onPressed: () {}, child: Text("STOP")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
