// lib/features/post_detail/presentation/screens/post_detail_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/post_detail/presentation/providers/post_detail_providers.dart';
import 'package:gamjatuigimdit/shared/domain/models/comment/comment.dart';
import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class PostDetailScreen extends ConsumerWidget {
  static const String name = 'PostDetailScreen';
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postDetailNotifierProvider(post));

    // 제목 분리
    final List<String> titleParts = post.title.split('\n원문: ');
    final translatedTitle = titleParts[0];
    final originalTitle = titleParts.length > 1 ? titleParts[1] : '';

    // 내용 분리
    final List<String> contentParts = post.selfText.split('\n원문: ');
    final translatedContent = contentParts[0];
    final originalContent = contentParts.length > 1 ? contentParts[1] : '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: state.isLoading ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 95, 201, 248))) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              Text(
                translatedTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (originalTitle.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  originalTitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // 메타 정보
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(post.author),
                  const SizedBox(width: 16),
                  Icon(Icons.arrow_upward, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(post.score.toString()),
                ],
              ),

              // 내용이 있는 경우에만 표시
              if (post.selfText.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  translatedContent,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (originalContent.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    '원문: $originalContent',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],

              // URL이 있는 경우
              if (post.url != null && post.url!.isNotEmpty && !post.url!.contains('reddit.com')) ...[
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => launchUrl(Uri.parse(post.url!)),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.link, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            post.url!,
                            style: TextStyle(
                              color: Colors.blue[700],
                              decoration: TextDecoration.underline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // 이미지가 있는 경우
              if (post.thumbnail != null &&
                  post.thumbnail!.isNotEmpty &&
                  post.thumbnail != 'self' &&
                  post.thumbnail != 'default') ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post.thumbnail!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(); // 이미지 로드 실패 시 빈 컨테이너
                    },
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // 댓글 섹션
              Text(
                '댓글 (${state.comments.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),

              // 댓글 목록
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.comments.length,
                itemBuilder: (context, index) {
                  return _buildComment(context, state.comments[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComment(BuildContext context, Comment comment, {double indentation = 0}) {
    final List<String> commentParts = comment.body.split('\n원문: ');
    final translatedComment = commentParts[0];
    final originalComment = commentParts.length > 1 ? commentParts[1] : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: EdgeInsets.only(bottom: 8.0, left: indentation),
          color: Colors.white,
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
                Text(
                  translatedComment,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (originalComment.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    '원문: $originalComment',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // 대댓글이 있는 경우 재귀적으로 표시
        if (comment.replies.isNotEmpty) ...[
          ...comment.replies.map((reply) => _buildComment(
            context,
            reply,
            indentation: indentation + 24.0,  // 대댓글마다 들여쓰기 증가
          )),
        ],
      ],
    );
  }
}