import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_framework/responsive_framework.dart';

ResponsiveBreakpointsData useBreakpoints() {
  final context = useContext();
  return ResponsiveBreakpoints.of(context);
}
