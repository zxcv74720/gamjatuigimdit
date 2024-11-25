import 'package:gamjatuigimdit/shared/domain/models/comment/comment.dart';
import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';

abstract class PostDetailRepository {
  Future<Either<AppException, List<Comment>>> getComments(String permalink);
}