import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/domain/data/ip_info.dart';
import 'package:radili/domain/local/app_box.dart';
import 'package:retry/retry.dart';

const _zgLatLng = LatLng(45.815399, 15.966568);

class LocationService {
  final AppBox _appBox;
  final Location _location;

  LocationAccuracy? _accuracy;

  LocationService(this._location, this._appBox);

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
    return AppLocation.fromLatLng(_zgLatLng, isMock: true);
  }

  Future<AppLocation?> getCached() {
    return _appBox.getLocation();
  }

  Future<AppLocation?> getCurrent({
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    try {
      await _requestPermission();
    } catch (e) {
      return null;
    }

    const r = RetryOptions(maxAttempts: 2);
    try {
      final result = await r.retry(
        () async {
          await _applyAccuracy(accuracy);
          final data = await _location.getLocation();
          final location = data.toAppLocation();
          return location;
        },
      );
      if (result != null) {
        // await _locationBox.setLocation(result);
      }
      return result;
    } catch (e) {}

    return null;
  }

  Future<void> _applyAccuracy(LocationAccuracy accuracy) async {
    if (_accuracy != accuracy) {
      _accuracy = accuracy;
      await _location.changeSettings(accuracy: accuracy);
    }
  }

  Future<void> _requestPermission() async {
    var status = await _location.hasPermission();
    if (!status.isGranted) {
      status = await _location.requestPermission();
    }
    if (!status.isGranted) {
      throw Exception('Location permission not granted');
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
