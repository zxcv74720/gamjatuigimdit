import 'package:gamjatuigimdit/features/post_detail/data/service/post_detail_service.dart';
import 'package:gamjatuigimdit/features/post_detail/domain/repositories/post_detail_repository.dart';
import 'package:gamjatuigimdit/shared/domain/models/comment/comment.dart';
import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';

class PostDetailRepositoryImpl implements PostDetailRepository {
  final PostDetailService _service;

  PostDetailRepositoryImpl(this._service);

  @override
  Future<Either<AppException, List<Comment>>> getComments(String permalink) {
    return _service.fetchComments(permalink);
  }
}