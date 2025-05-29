import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:appturismo/model/place_model.dart';

class PlaceMarkerWidget {
  static Marker buildMarker(Place place) {
    return Marker(
      point: LatLng(place.latitude, place.longitude),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () {},
        child: const Icon(Icons.location_on, color: Colors.blue, size: 40),
      ),
    );
  }
}
