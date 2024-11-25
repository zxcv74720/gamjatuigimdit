import 'package:gamjatuigimdit/features/post_list/data/service/post_list_service.dart';
import 'package:gamjatuigimdit/features/post_list/domain/repositories/post_list_repository.dart';
import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/post_response_model.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';

class PostListRepositoryImpl extends PostListRepository {
  final PostListService _service;

  PostListRepositoryImpl(this._service);

  @override
  Future<Either<AppException, PostResponse>> getPosts({String? after}) {
    return _service.fetchPosts(after: after);
  }
}
