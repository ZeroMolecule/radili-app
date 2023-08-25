class FormError extends Error {
  final String message;

  FormError(this.message);

  @override
  String toString() {
    return 'FormError: $message';
  }
}
