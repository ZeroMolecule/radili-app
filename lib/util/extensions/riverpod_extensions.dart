import 'package:hooks_riverpod/hooks_riverpod.dart';

extension RefExtensions on Ref {
  Future<void> debounce(Duration duration) async {
    var didDispose = false;
    onDispose(() {
      didDispose = true;
    });

    await Future.delayed(duration);

    if (didDispose) {
      throw Exception('Ref disposed');
    }
  }
}
