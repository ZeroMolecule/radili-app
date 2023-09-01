import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:radili/domain/data/subsidiary.dart';

part 'nearby_subsidiaries_query.freezed.dart';

@Freezed(fromJson: false, toJson: false)
class NearbySubsidiariesQuery with _$NearbySubsidiariesQuery {
  static const empty = NearbySubsidiariesQuery(
    openSunday: false,
    openNow: false,
  );

  const NearbySubsidiariesQuery._();

  const factory NearbySubsidiariesQuery({
    @Default(false) bool openSunday,
    @Default(false) bool openNow,
  }) = _NearbySubsidiariesQuery;

  bool validateSubsidiary(Subsidiary subsidiary) {
    if (openSunday && subsidiary.workHours.sunday == null) {
      return false;
    }
    if (openNow && subsidiary.workHours.getForToday() == null) {
      return false;
    }
    return true;
  }
}
