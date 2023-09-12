import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

FormGroup useForm(
  Map<String, AbstractControl<dynamic>> controls, {
  List<Validator> validators = const [],
  List<AsyncValidator> asyncValidators = const [],
  int asyncValidatorsDebounceTime = 250,
  bool disabled = false,
  List keys = const [],
}) {
  final form = useMemoized(
    () => FormGroup(
      controls,
      validators: validators,
      asyncValidators: asyncValidators,
      asyncValidatorsDebounceTime: asyncValidatorsDebounceTime,
      disabled: disabled,
    ),
    keys,
  );

  useStream(form.statusChanged);

  return form;
}
