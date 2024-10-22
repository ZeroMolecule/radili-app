import 'dart:math';

extension StringExtensions on String {
  String getInitials(int count, {bool uppercase = true}) {
    if (isEmpty) return '';

    var input = trim();
    final words = input.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final initialCount = min(count, words.length);

    var initials = words.take(initialCount);
    if (uppercase) {
      initials = initials.map((w) => w[0].toUpperCase());
    }
    return initials.join('');
  }

  String removeDiacritics() {
    const accentMap = {
      '[čć]': 'c',
      '[đ]': 'd',
      '[š]': 's',
      '[ž]': 'z',
      '[ČĆ]': 'C',
      '[Đ]': 'D',
      '[Š]': 'S',
      '[Ž]': 'Z',
    };

    var str = this;
    accentMap.forEach((pattern, replacement) {
      str = str.replaceAll(RegExp(pattern), replacement);
    });

    return str;
  }
}
