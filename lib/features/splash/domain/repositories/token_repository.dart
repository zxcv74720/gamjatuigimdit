import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/token/token_model.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';

abstract class TokenRepository {
  Future<Either<AppException, Token>> getAccessToken();
}

