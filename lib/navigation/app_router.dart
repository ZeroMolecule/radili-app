import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:radili/domain/data/address_info.dart';
import 'package:radili/flow/map/map_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: MapRoute.page,
          initial: true,
        ),
      ];
}
