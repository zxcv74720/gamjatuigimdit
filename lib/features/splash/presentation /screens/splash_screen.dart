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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 95, 201, 248),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(); // 이미지 로드 실패 시 빈 컨테이너
          },
        ),
      ),
    );
  }
}