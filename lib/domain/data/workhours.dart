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

  String? getForDay(DateTime date) {
    switch (date.weekday) {
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

  String? getForToday() {
    return getForDay(DateTime.now());
  }

  Map<int, String?> byDay() {
    return {
      DateTime.monday: monday,
      DateTime.tuesday: tuesday,
      DateTime.wednesday: wednesday,
      DateTime.thursday: thursday,
      DateTime.friday: friday,
      DateTime.saturday: saturday,
      DateTime.sunday: sunday,
    };
  }
}
