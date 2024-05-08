import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:radili/domain/data/store.dart';
import 'package:radili/generated/assets.gen.dart';
import 'package:radili/generated/colors.gen.dart';
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
    final uri = linker.buildDiscountsLink(store);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        Align(
          alignment: Alignment.center,
          child: _JelposkupiloShoutout(store: store),
        ),
      ],
    );
  }
}

class _JelposkupiloShoutout extends HookWidget {
  final Store store;

  const _JelposkupiloShoutout({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final linker = useLinker();

    final discountsUrl = linker.buildDiscountsLink(store);
    final baseUrl = useMemoized(() {
      return Uri(
        scheme: discountsUrl.scheme,
        host: discountsUrl.host,
      );
    }, [discountsUrl]);

    return InkWell(
      onTap: () => linker.launch(baseUrl),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.jelposkupilo.svg(height: 16, width: 16),
          const SizedBox(width: 6),
          Text(
            baseUrl.host,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
