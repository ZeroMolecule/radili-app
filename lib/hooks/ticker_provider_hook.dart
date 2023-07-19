import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

TickerProvider useTickerProvider() {
  return use(const _TickerProviderHook());
}

class _TickerProviderHook extends Hook<TickerProvider> {
  const _TickerProviderHook();

  @override
  _TickerProviderHookState createState() => _TickerProviderHookState();
}

class _TickerProviderHookState
    extends HookState<TickerProvider, _TickerProviderHook> {
  late TickerProvider tickerProvider;

  @override
  void initHook() {
    super.initHook();
    tickerProvider = _TickerProviderImpl();
  }

  @override
  TickerProvider build(BuildContext context) {
    return tickerProvider;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _TickerProviderImpl implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
