import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OsmMapView extends StatelessWidget {
  final List<LatLng> coordinateList;
  final LatLng? location;
  final Color coloreTracciato;

  const OsmMapView({
    super.key,
    required this.coordinateList,
    required this.location,
    required this.coloreTracciato,
  });

  @override
  Widget build(BuildContext context) {
    final centro = location ?? (coordinateList.isNotEmpty ? coordinateList.last : LatLng(0, 0));

    return FlutterMap(
      options: MapOptions(
        center: centro,
        zoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        if (coordinateList.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: coordinateList,
                color: coloreTracciato,
                strokeWidth: 4.0,
              ),
            ],
          ),
        if (location != null)
          MarkerLayer(
            markers: [
              Marker(
                point: location!,
                width: 64,
                height: 64,
                builder: (ctx) => Image.asset(
                  'assets/ic_my_location.png',
                  width: 64,
                  height: 64,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
