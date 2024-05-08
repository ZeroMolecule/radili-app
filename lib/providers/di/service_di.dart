import 'package:location/location.dart';
import 'package:radili/domain/service/location_service.dart';
import 'package:radili/providers/di/di.dart';

void injectServices() {
  di.registerSingleton(LocationService(Location(), di.get()));
}
