import 'package:gamjatuigimdit/shared/domain/models/token/token_model.dart';

class TokenState {
  final Token? token;
  final bool isLoading;
  final String? error;

  TokenState({
    this.token,
    this.isLoading = false,
    this.error,
  });

  TokenState copyWith({
    Token? token,
    bool? isLoading,
    String? error,
  }) {
    return TokenState(
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}