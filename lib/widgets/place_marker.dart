import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:appturismo/model/place_model.dart';

class PlaceMarkerWidget {
  /// Crea un [Marker] a partir de un [PlaceModel]
  static Marker buildMarker(Place place) {
    return Marker(
      markerId: MarkerId(place.id),
      position: LatLng(place.latitude, place.longitude),
      infoWindow: InfoWindow(title: place.name, snippet: place.description),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
  }
}
