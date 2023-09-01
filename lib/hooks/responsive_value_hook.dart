import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:responsive_framework/responsive_value.dart';

T? useResponsiveValue<T>({
  required List<Condition<T>> conditions,
}) {
  final context = useContext();
  return ResponsiveValue<T>(
    context,
    conditionalValues: conditions,
  ).value;
}

T useResponsiveValueReq<T>({
  required T defaultValue,
  required List<Condition<T>> conditions,
}) {
  final responsive = useResponsiveValue(conditions: conditions);
  return responsive ?? defaultValue;
}
