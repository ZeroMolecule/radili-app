import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/domain/data/ip_info.dart';

const _zgLatLng = LatLng(45.815399, 15.966568);

class LocationService {
  final Location _location;

  LocationAccuracy? _accuracy;

  LocationService(this._location);

  Future<bool> isPermissionEnabled() async {
    final permissionStatus = await _location.hasPermission();
    final serviceEnabled = await _location.serviceEnabled();
    return permissionStatus.isGranted && serviceEnabled;
  }

  Future<bool> requestPermissions() async {
    var permissionStatus = await _location.hasPermission();
    var serviceEnabled = await _location.serviceEnabled();
    if (!permissionStatus.isGranted) {
      permissionStatus = await _location.requestPermission();
    }
    if (permissionStatus.isGranted && !serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    return permissionStatus.isGranted && serviceEnabled;
  }

  Future<AppLocation> getFallback() async {
    return AppLocation.fromLatLng(_zgLatLng);
  }

  Future<AppLocation> getCurrent({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    final isPermissionAllowed = await requestPermissions();
    if (isPermissionAllowed) {
      await _applyAccuracy(accuracy);
      final data = await _location.getLocation();
      final location = data.toAppLocation();
      if (location != null) {
        return location;
      }
    }
    return await getFallback();
  }

  Stream<AppLocation> watchCurrent() async* {
    final isPermissionAllowed = await requestPermissions();
    if (isPermissionAllowed) {
      await _applyAccuracy(LocationAccuracy.high);
      yield* _location.onLocationChanged
          .map((data) => data.toAppLocation())
          .where((location) => location != null)
          .map((location) => location!);
    }
    yield await getFallback();
  }

  Future<void> _applyAccuracy(LocationAccuracy accuracy) async {
    if (_accuracy != accuracy) {
      _accuracy = accuracy;
      await _location.changeSettings(accuracy: accuracy);
    }
  }
}

extension _PermissionStatusExtensions on PermissionStatus {
  static const List<PermissionStatus> _acceptablePermissions = [
    PermissionStatus.granted,
    PermissionStatus.grantedLimited,
  ];

  bool get isGranted => _acceptablePermissions.contains(this);
}

extension _LocationDataExtensions on LocationData {
  bool get isValid => latitude != null && longitude != null;

  AppLocation? toAppLocation() {
    if (!isValid) {
      return null;
    }
    return AppLocation(
      latitude: latitude!,
      longitude: longitude!,
      accuracy: accuracy ?? 0.0,
      heading: heading ?? 0.0,
      isMock: isMock ?? false,
    );
  }
}

extension _IpInfoExtensions on IpInfo {
  AppLocation toAppLocation() {
    return AppLocation(
      latitude: lat,
      longitude: lon,
      accuracy: 0.0,
      heading: 0.0,
      isMock: false,
    );
  }
}
