import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/paginated_response.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';
import 'package:gamjatuigimdit/shared/globals.dart';
import 'package:gamjatuigimdit/shared/remote/remote.dart';

abstract class PostListDatasource {
  Future<Either<AppException, PaginatedResponse>> fetchPaginatedPosts(
      {required int skip});
  Future<Either<AppException, PaginatedResponse>> searchPaginatedPosts(
      {required int skip, required String query});
}

class PostListRemoteDatasource extends PostListDatasource {
  final NetworkService networkService;
  PostListRemoteDatasource(this.networkService);

  @override
  Future<Either<AppException, PaginatedResponse>> fetchPaginatedPosts(
      {required int skip}) async {
    final response = await networkService.get(
      '/products',
      queryParameters: {
        'skip': skip,
        'limit': POSTS_PER_PAGE,
      },
    );

    return response.fold(
          (l) => Left(l),
          (r) {
        final jsonData = r.data;
        if (jsonData == null) {
          return Left(
            AppException(
              identifier: 'fetchPaginatedData',
              statusCode: 0,
              message: 'The data is not in the valid format.',
            ),
          );
        }
        final paginatedResponse =
        PaginatedResponse.fromJson(jsonData, jsonData['posts'] ?? []);
        return Right(paginatedResponse);
      },
    );
  }

  @override
  Future<Either<AppException, PaginatedResponse>> searchPaginatedPosts(
      {required int skip, required String query}) async {
    final response = await networkService.get(
      '/posts/search?q=$query',
      queryParameters: {
        'skip': skip,
        'limit': POSTS_PER_PAGE,
      },
    );

    return response.fold(
          (l) => Left(l),
          (r) {
        final jsonData = r.data;
        if (jsonData == null) {
          return Left(
            AppException(
              identifier: 'search PaginatedData',
              statusCode: 0,
              message: 'The data is not in the valid format.',
            ),
          );
        }
        final paginatedResponse =
        PaginatedResponse.fromJson(jsonData, jsonData['posts'] ?? []);
        return Right(paginatedResponse);
      },
    );
  }
}