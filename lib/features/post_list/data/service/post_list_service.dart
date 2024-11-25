import 'package:gamjatuigimdit/configs/app_configs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart';
import 'package:gamjatuigimdit/shared/domain/models/post_response_model.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';
import 'package:logger/logger.dart';

abstract class PostListService {
  Future<Either<AppException, PostResponse>> fetchPosts({String? after});
}

class PostListServiceImpl extends PostListService {
  final String? token;

  PostListServiceImpl(this.token);

  @override
  Future<Either<AppException, PostResponse>> fetchPosts({String? after}) async {
    try {
      final queryParams = {
        'limit': '20',
        if (after != null) 'after': after,
        'g': 'GLOBAL',
        'show': 'all'
      };

      final Uri uri = Uri.parse('${AppConfigs.redditUrl}/r/FlutterDev/hot').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'bearer $token',
          'User-Agent': 'MyFlutterApp/1.0',
        },
      );

      Logger().i(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Post> posts = [];

        final children = data['data']['children'] as List;
        posts = children
            .map((post) => Post.fromJson(post['data']))
            .toList();

        return Right(PostResponse(
            posts: posts,
            nextPageId: data['data']['after']
        ));
      }

      return Left(AppException(
        message: 'Failed to fetch posts',
        statusCode: response.statusCode,
        identifier: 'RedditPostService',
      ));
    } catch (e) {
      return Left(AppException(
        message: e.toString(),
        statusCode: 500,
        identifier: 'RedditPostService',
      ));
    }
  }
}