import 'package:location/location.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:rxdart/rxdart.dart';

class LocationService {
  final Location _location;

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

  Future<AppLocation?> getCurrent() async {
    final isPermissionAllowed = await requestPermissions();
    if (isPermissionAllowed) {
      final data = await _location.getLocation();
      return data.toAppLocation();
    }
    return null;
  }

  Stream<AppLocation> watchCurrent() async* {
    var isPermissionEnabled = await requestPermissions();
    while (!isPermissionEnabled) {
      await Future.delayed(const Duration(seconds: 5));
      isPermissionEnabled = await this.isPermissionEnabled();
    }
    final current = await getCurrent();
    if (current != null) {
      yield current;
      yield* _location.onLocationChanged
          .map((event) => event.toAppLocation())
          .whereNotNull();
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
