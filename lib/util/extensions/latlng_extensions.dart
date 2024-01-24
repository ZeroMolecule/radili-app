import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;

extension LatLngExtensions on LatLng {
  mt.LatLng toMapToolkitLatLng() => mt.LatLng(latitude, longitude);
}
