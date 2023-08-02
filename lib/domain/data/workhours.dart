import 'package:freezed_annotation/freezed_annotation.dart';

part 'workhours.freezed.dart';
part 'workhours.g.dart';

@freezed
class WorkHours with _$WorkHours {
  const WorkHours._();

  const factory WorkHours({
    required String? monday,
    required String? tuesday,
    required String? wednesday,
    required String? thursday,
    required String? friday,
    required String? saturday,
    required String? sunday,
  }) = _WorkHours;

  factory WorkHours.fromJson(Map<String, Object?> json) =>
      _$WorkHoursFromJson(json);

  String? getToday() {
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        return monday;
      case DateTime.tuesday:
        return tuesday;
      case DateTime.wednesday:
        return wednesday;
      case DateTime.thursday:
        return thursday;
      case DateTime.friday:
        return friday;
      case DateTime.saturday:
        return saturday;
      case DateTime.sunday:
        return sunday;
      default:
        return null;
    }
  }

  Map<String, String?> getMapped() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
    };
  }
}
