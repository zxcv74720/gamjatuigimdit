import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/paginated_response.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';

abstract class PostListRepository {
  Future<Either<AppException, PaginatedResponse>> fetchPosts(
      {required int skip});
}
