import 'package:auto_route/auto_route.dart';
import 'package:gamjatuigimdit/routes/app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: PostListRoute.page),
    AutoRoute(page: PostDetailRoute.page),
  ];
}