import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radili/theme/app_theme.dart';

final themeLightProvider = Provider((ref) => AppTheme.light());
final themeDarkProvider = Provider((ref) => AppTheme.dark());
