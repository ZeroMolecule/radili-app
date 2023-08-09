import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

FormGroup useForm(
  Map<String, AbstractControl<dynamic>> controls, {
  List<Validator> validators = const [],
  List<AsyncValidator> asyncValidators = const [],
  int asyncValidatorsDebounceTime = 250,
  bool disabled = false,
}) {
  final form = useRef(
    FormGroup(
      controls,
      validators: validators,
      asyncValidators: asyncValidators,
      asyncValidatorsDebounceTime: asyncValidatorsDebounceTime,
      disabled: disabled,
    ),
  ).value;

  useStream(form.statusChanged);

  return form;
}
