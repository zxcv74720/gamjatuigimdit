// post_detail_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'dart:convert';

@RoutePage()
class PostDetailScreen extends ConsumerStatefulWidget {
  static const String name = 'PostDetailScreen';

  final Post post;

  const PostDetailScreen({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final translator = GoogleTranslator();
  List<Comment> comments = [];
  bool isLoading = true;
  String? translatedTitle;
  String? translatedContent;

  @override
  void initState() {
    super.initState();
    loadPostDetails();
  }

  Future<void> loadPostDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 제목과 내용 번역
      translatedTitle = await translateText(widget.post.title);
      if (widget.post.selfText.isNotEmpty) {
        translatedContent = await translateText(widget.post.selfText);
      }

      // 댓글 로드 및 번역
      await fetchComments();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.reddit.com${widget.post.permalink}.json'),
        headers: {
          'User-Agent': 'MyFlutterApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.length > 1) {
          final commentData = data[1]['data']['children'];
          List<Comment> newComments = [];

          for (var comment in commentData) {
            if (comment['kind'] == 't1') {  // 일반 댓글만 처리
              String translatedBody = await translateText(comment['data']['body'] ?? '');
              newComments.add(Comment(
                author: comment['data']['author'],
                body: comment['data']['body'] ?? '',
                translatedBody: translatedBody,
                score: comment['data']['score'],
              ));
            }
          }

          setState(() {
            comments = newComments;
          });
        }
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<String> translateText(String text) async {
    if (text.isEmpty) return '';
    try {
      var translation = await translator.translate(text, to: 'ko');
      return translation.text;
    } catch (e) {
      print('Translation error: $e');
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시물 상세'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 게시물 제목
              Text(
                translatedTitle ?? widget.post.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              // 원문 제목
              Text(
                '원문: ${widget.post.title}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),

              // 메타 정보
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(widget.post.author),
                  const SizedBox(width: 16),
                  Icon(Icons.arrow_upward, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(widget.post.score.toString()),
                ],
              ),
              const SizedBox(height: 16),

              // 게시물 내용
              if (widget.post.selfText.isNotEmpty) ...[
                Text(
                  translatedContent ?? widget.post.selfText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '원문: ${widget.post.selfText}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
              ],

              // 댓글 섹션
              Text(
                '댓글 (${comments.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                comment.author,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_upward, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(comment.score.toString()),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(comment.translatedBody),
                          const SizedBox(height: 4),
                          Text(
                            '원문: ${comment.body}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Comment {
  final String author;
  final String body;
  final String translatedBody;
  final int score;

  Comment({
    required this.author,
    required this.body,
    required this.translatedBody,
    required this.score,
  });
}