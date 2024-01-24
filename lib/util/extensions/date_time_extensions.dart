import 'package:intl/intl.dart';

String dayKey(int day) {
  switch (day) {
    case DateTime.monday:
      return 'monday';
    case DateTime.tuesday:
      return 'tuesday';
    case DateTime.wednesday:
      return 'wednesday';
    case DateTime.thursday:
      return 'thursday';
    case DateTime.friday:
      return 'friday';
    case DateTime.saturday:
      return 'saturday';
    case DateTime.sunday:
      return 'sunday';
    default:
      return '';
  }
}

extension DateTimeExtensions on DateTime {
  int get weekNumber {
    final dayOfYear = int.parse(DateFormat('D').format(this));
    final woy = ((dayOfYear - weekday + 10) / 7).floor();
    return woy;
  }

  bool isSameWeekAs(DateTime other) {
    return weekNumber == other.weekNumber;
  }
}
