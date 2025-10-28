import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stepontrackflutter/ui/view/MyTopAppBar.dart';

class MappaPercorsoScreen extends StatefulWidget {
  final String percorsoId;
  const MappaPercorsoScreen({super.key, required this.percorsoId});

  @override
  _MappaPercorsoScreenState createState() => _MappaPercorsoScreenState();
}

class _MappaPercorsoScreenState extends State<MappaPercorsoScreen> {
  final MapController mapController = MapController();
  List<LatLng> coordinate = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPercorso();
  }

  Future<void> _loadPercorso() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Percorso')
          .doc(widget.percorsoId)
          .get();

      if (doc.exists) {
        final coords = doc['coordinate'] as List<dynamic>;

        List<LatLng> polylinePoints = coords.map((p) {
          final point = p as GeoPoint;
          return LatLng(point.latitude, point.longitude);
        }).toList();

        setState(() {
          coordinate = polylinePoints;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        print("Percorso non trovato");
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print("Errore recupero percorso: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Se non ci sono coordinate, centro mappa su 0,0
    final centro = coordinate.isNotEmpty ? coordinate.first : LatLng(0, 0);

    return Scaffold(
      appBar: MyTopBar(title: "Percorso"),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: centro,
          zoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          if (coordinate.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: coordinate,
                  color: Colors.blue,
                  strokeWidth: 4.0,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
