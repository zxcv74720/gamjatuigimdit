import 'dart:convert';

import 'package:gamjatuigimdit/configs/app_configs.dart';
import 'package:gamjatuigimdit/shared/domain/models/comment/comment.dart';
import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:translator/translator.dart';

class PostDetailService {
  final String? token;
  final translator = GoogleTranslator();
  final HtmlUnescape _unescape = HtmlUnescape();

  PostDetailService(this.token);

  Future<Either<AppException, List<Comment>>> fetchComments(String permalink) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfigs.redditUrl}$permalink.json'),
        headers: {
          'Authorization': 'bearer $token',
          'User-Agent': 'MyFlutterApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.length > 1) {
          final commentData = data[1]['data']['children'];
          List<Comment> comments = [];

          for (var comment in commentData) {
            if (comment['kind'] == 't1') {
              final body = _unescape.convert(comment['data']['body'] ?? '');

              String translatedBody = '';
              try {
                final translation = await translator.translate(body, to: 'ko');
                translatedBody = '${translation.text}\n원문: $body';
              } catch (e) {
                Logger().e('Translation error: $e');
                translatedBody = body;
              }

              // 대댓글 처리
              List<Comment> replies = [];
              if (comment['data']['replies'] != null &&
                  comment['data']['replies'] != '' &&
                  comment['data']['replies']['data'] != null) {
                final repliesData = comment['data']['replies']['data']['children'] as List;
                for (var reply in repliesData) {
                  if (reply['kind'] == 't1') {
                    final replyBody = _unescape.convert(
                        reply['data']['body'] ?? '');

                    String translatedReplyBody = '';
                    try {
                      final replyTranslation = await translator.translate(
                          replyBody, to: 'ko');
                      translatedReplyBody =
                      '${replyTranslation.text}\n원문: $replyBody';
                    } catch (e) {
                      Logger().e('Translation error in reply: $e');
                      translatedReplyBody = replyBody;
                    }

                    replies.add(Comment(
                      author: reply['data']['author'],
                      body: translatedReplyBody,
                      score: reply['data']['score'],
                    ));
                  }
                }
              }

              comments.add(Comment(
                author: comment['data']['author'],
                body: translatedBody,
                score: comment['data']['score'],
                replies: replies,
              ));
            }
          }
          return Right(comments);
        }
      }

      return Left(AppException(
        message: 'Failed to fetch comments',
        statusCode: response.statusCode,
        identifier: 'PostDetailService',
      ));
    } catch (e) {
      return Left(AppException(
        message: e.toString(),
        statusCode: 500,
        identifier: 'PostDetailService',
      ));
    }
  }

  Future<Comment> _parseComment(dynamic commentData) async {
    String body = commentData['body'] ?? '';
    body = _unescape.convert(body);

    try {
      final translatedBody = await translator.translate(body, to: 'ko');
      body = '${translatedBody.text}\n원문: $body';
    } catch (e) {
      Logger().e('Translation error: $e');
    }

    // 대댓글 처리
    List<Comment> replies = [];
    if (commentData['replies'] != null &&
        commentData['replies'] != '' &&
        commentData['replies']['data'] != null) {
      final repliesData = commentData['replies']['data']['children'] as List;
      replies = await Future.wait(
          repliesData
              .where((reply) => reply['kind'] == 't1')  // 일반 댓글만 처리
              .map((reply) => _parseComment(reply['data']))
      );
    }

    return Comment(
      author: commentData['author'] ?? '',
      body: body,
      score: commentData['score'] ?? 0,
      replies: replies,
    );
  }
}

