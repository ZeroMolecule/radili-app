import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

FormGroup useForm(
  Map<String, AbstractControl<dynamic>> controls, {
  List<ValidatorFunction> validators = const [],
  List<AsyncValidatorFunction> asyncValidators = const [],
  int asyncValidatorsDebounceTime = 250,
  bool disabled = false,
  bool observeChanges = true,
  List<Object?> keys = const [],
}) {
  final form = useMemoized(() {
    return FormGroup(
      controls,
      validators: [],
      asyncValidators: [],
      asyncValidatorsDebounceTime: asyncValidatorsDebounceTime,
      disabled: disabled,
    );
  }, keys);

  final stream = useMemoized(() {
    if (observeChanges) {
      return form.statusChanged;
    }
    return const Stream.empty();
  }, [observeChanges]);

  useStream(stream);
  return form;
}

T? useFormControl<T>(FormControl<T> control) {
  return useStream(control.valueChanges, initialData: control.value).data;
}
