import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/splash/domain/repositories/token_repository.dart';
import 'package:gamjatuigimdit/features/splash/presentation%20/providers/state/token_state.dart';

class TokenStateNotifier extends StateNotifier<TokenState> {
  final TokenRepository _repository;

  TokenStateNotifier(this._repository) : super(TokenState());

  Future<void> getAccessToken() async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.getAccessToken();

    result.fold((failure) => state = state.copyWith(
        error: failure.message,
        isLoading: false,
      ),
          (token) => state = state.copyWith(
        token: token,
        isLoading: false,
      ),
    );
  }
}