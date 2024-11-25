import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../routes/app_route.dart';
import '../../../../routes/app_route.gr.dart';

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  static const String name = '/splashScreen';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final AppRouter appRouter = AppRouter();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      // final isUserLoggedIn = await ref.read(userLoginCheckProvider.future);
      // final route = isUserLoggedIn
      //     ? const DashboardRoute()
      //     : LoginRoute() as PageRouteInfo;
      // ignore: use_build_context_synchronously
      AutoRouter.of(context).pushAndPopUntil(
        const PostListRoute(),
        predicate: (_) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const Center(
        child: Text(
          'Splash Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}