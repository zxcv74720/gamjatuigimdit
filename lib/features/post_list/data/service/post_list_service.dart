import 'package:gamjatuigimdit/configs/app_configs.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart';
import 'package:gamjatuigimdit/shared/domain/models/post_response_model.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';
import 'package:logger/logger.dart';
import 'package:translator/translator.dart';

abstract class PostListService {
  Future<Either<AppException, PostResponse>> fetchPosts({String? after});
}

class PostListServiceImpl extends PostListService {
  final String? token;
  final HtmlUnescape _unescape = HtmlUnescape();
  final translator = GoogleTranslator();

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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Post> posts = [];

        final children = data['data']['children'] as List;

        posts = await Future.wait(children.map((post) async {
          var postData = post['data'];

          final title = _unescape.convert(postData['title'])
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
          try {
            final translatedTitle = await translator.translate(title, to: 'ko');
            postData['title'] = '${translatedTitle.text}\n원문: $title';
          } catch (e) {
            Logger().e('Translation error for title: $e');
            postData['title'] = title;
          }

          if (postData['selftext'] != null && postData['selftext'].isNotEmpty) {
            String selfText = _unescape.convert(postData['selftext']);

            selfText = selfText.replaceAll(r'\n', '\n')
                .replaceAll(r'\r', '')
                .replaceAll(r'\t', '  ')
                .replaceAll(r'\"', '"')
                .replaceAll(r'\\', '\\');

            selfText = selfText.split('\n')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .join('\n\n');

            try {
              final translatedContent = await translator.translate(selfText, to: 'ko');
              postData['selftext'] = '${translatedContent.text}\n원문: $selfText';
            } catch (e) {
              Logger().e('Translation error for content: $e');
              postData['selftext'] = selfText;
            }
          }

          return Post.fromJson(postData);
        }));

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