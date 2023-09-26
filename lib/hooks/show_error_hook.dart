import 'package:radili/hooks/error_parser_hook.dart';
import 'package:radili/hooks/show_snackbar_hook.dart';
import 'package:radili/hooks/theme_hook.dart';

Function(Object error, [StackTrace? stack]) useShowError() {
  final errorParser = useErrorParser();
  final colorScheme = useTheme().material.colorScheme;
  final showSnackBar = useShowSnackBar(backgroundColor: colorScheme.error);

  return (Object error, [StackTrace? stack]) {
    final message = errorParser.parse(error);
    showSnackBar(message);
  };
}
