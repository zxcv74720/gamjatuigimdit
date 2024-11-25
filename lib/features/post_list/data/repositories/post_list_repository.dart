import 'package:gamjatuigimdit/features/post_list/data/datasource/post_list_remote_datasource.dart';
import 'package:gamjatuigimdit/features/post_list/domain/repositories/post_list_repository.dart';
import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/paginated_response.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';

class PostListRepositoryImpl extends PostListRepository {
  final PostListDatasource postListDatasource;
  PostListRepositoryImpl(this.postListDatasource);

  @override
  Future<Either<AppException, PaginatedResponse>> fetchPosts(
      {required int skip}) {
    return postListDatasource.fetchPaginatedPosts(skip: skip);
  }
}