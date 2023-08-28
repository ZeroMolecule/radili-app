import 'package:location/location.dart';
import 'package:radili/domain/data/app_location.dart';
import 'package:radili/domain/data/ip_info.dart';
import 'package:radili/domain/remote/ip_api.dart';
import 'package:radili/domain/remote/util_api.dart';

class LocationService {
  final Location _location;
  final IpApi _ipApi;
  final UtilApi _utilApi;

  LocationService(this._location, this._ipApi, this._utilApi);

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

  Future<AppLocation> _getFallback() async {
    final ip = await _utilApi.getMyIp();
    final info = await _ipApi.getInfo(ip: ip);
    return info.toAppLocation();
  }

  Future<AppLocation> getCurrent() async {
    final isPermissionAllowed = await requestPermissions();
    if (isPermissionAllowed) {
      final data = await _location.getLocation();
      final location = data.toAppLocation();
      if (location != null) {
        return location;
      }
    }
    return await _getFallback();
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
