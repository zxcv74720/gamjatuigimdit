import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/splash/domain/providers/token_providers.dart';
import 'package:logger/logger.dart';
import '../../../../routes/app_route.gr.dart';

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  static const String name = '/splashScreen';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    await ref.read(tokenStateProvider.notifier).getAccessToken();

    final authState = ref.read(tokenStateProvider);

    if (authState.error != null) {
      Logger().i('Auth Error: ${authState.error}');
      return;
    }

    if (authState.token != null) {
      // ignore: use_build_context_synchronously
      AutoRouter.of(context).pushAndPopUntil(
        const PostListRoute(),
        predicate: (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(tokenStateProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: authState.isLoading
            ? const CircularProgressIndicator()
            : const Text(
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