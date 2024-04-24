import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:radili/domain/data/store.dart';
import 'package:radili/hooks/linker_hook.dart';

class StoreDiscounts extends HookWidget {
  final Store store;
  final BoxConstraints constraints;

  const StoreDiscounts({
    super.key,
    required this.store,
    this.constraints = const BoxConstraints(minHeight: 320, maxHeight: 320),
  });

  @override
  Widget build(BuildContext context) {
    final linker = useLinker();
    final uri = linker.getDiscountsUri(store);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: constraints,
          child: Stack(
            fit: StackFit.expand,
            children: [
              const Center(child: CircularProgressIndicator()),
              Positioned.fill(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri.uri(uri)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
