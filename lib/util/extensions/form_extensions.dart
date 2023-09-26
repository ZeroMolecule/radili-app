import 'package:collection/collection.dart';
import 'package:radili/util/errors/form_error.dart';
import 'package:reactive_forms/reactive_forms.dart';

extension ReactiveFormGroupExtensions on FormGroup {
  void throwIfInvalid(Map<String, Object> errors) {
    if (!valid) {
      _throw(this.errors, errors);
    }
  }

  void _throw(Map allErrors, Map handledErrors) {
    final error = handledErrors.entries.firstWhereOrNull(
      (e) => allErrors.containsKey(e.key),
    );
    if (error == null) return;
    if (error.value is Map) {
      _throw(error.value as Map, handledErrors[error.key]);
    } else {
      throw FormError(handledErrors[error.key]);
    }
  }

  Object? findError(Map<String, Object> errors) {
    try {
      throwIfInvalid(errors);
      return null;
    } catch (e) {
      return e;
    }
  }
}
