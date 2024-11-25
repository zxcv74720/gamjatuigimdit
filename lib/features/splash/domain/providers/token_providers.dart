import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/splash/data/repositories/token_repository_impl.dart';
import 'package:gamjatuigimdit/features/splash/data/services/token_service.dart';
import 'package:gamjatuigimdit/features/splash/domain/repositories/token_repository.dart';
import 'package:gamjatuigimdit/features/splash/presentation%20/providers/state/token_notifier.dart';
import 'package:gamjatuigimdit/features/splash/presentation%20/providers/state/token_state.dart';

/// Service Provider
final tokenServiceProvider = Provider<TokenService>(
      (ref) => TokenService(),
);

/// Repository Provider
final tokenRepositoryProvider = Provider<TokenRepository>((ref) {
  final service = ref.watch(tokenServiceProvider);
  return TokenRepositoryImpl(service);
});

/// State Notifier Provider
final tokenStateProvider = StateNotifierProvider<TokenStateNotifier, TokenState>((ref) {
  final repository = ref.watch(tokenRepositoryProvider);
  return TokenStateNotifier(repository);
});

/// Token Provider (다른 feature에서 토큰 접근할 때 사용)
final tokenProvider = Provider<String?>((ref) {
  final authState = ref.watch(tokenStateProvider);
  return authState.token?.accessToken;
});