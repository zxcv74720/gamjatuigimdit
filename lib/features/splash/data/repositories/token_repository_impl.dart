import 'package:gamjatuigimdit/features/splash/data/services/token_service.dart';
import 'package:gamjatuigimdit/features/splash/domain/repositories/token_repository.dart';
import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/token/token_model.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';

class TokenRepositoryImpl implements TokenRepository {
  final TokenService _service;

  TokenRepositoryImpl(this._service);

  @override
  Future<Either<AppException, Token>> getAccessToken() {
    return _service.fetchAccessToken();
  }
}