import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/post_response_model.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';

abstract class PostListRepository {
  Future<Either<AppException, PostResponse>> getPosts({String? after});
}

