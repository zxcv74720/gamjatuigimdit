// post_list_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../post_detail/presentation/screens/post_detail_screen.dart';

@RoutePage()
class PostListScreen extends ConsumerStatefulWidget {
  static const String name = 'PostListScreen';

  const PostListScreen({super.key});

  @override
  ConsumerState<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends ConsumerState<PostListScreen> {
  final scrollController = ScrollController();
  List<RedditPost> posts = [];
  bool isLoading = false;
  bool hasMore = true;
  String? afterId;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.8 &&
        !isLoading &&
        hasMore) {
      fetchPosts();
    }
  }

  Future<void> refresh() async {
    setState(() {
      posts.clear();
      afterId = null;
      hasMore = true;
    });
    await fetchPosts();
  }

  Future<void> fetchPosts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final Uri uri = Uri.parse(
          'https://www.reddit.com/r/Flutter/hot.json' +
              (afterId != null ? '?after=$afterId' : '') +
              (afterId == null ? '?limit=20' : '&limit=20')
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MyFlutterApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<RedditPost> newPosts = [];

        afterId = data['data']['after'];
        hasMore = afterId != null;

        for (var post in data['data']['children']) {
          newPosts.add(RedditPost.fromJson(post['data']));
        }

        setState(() {
          posts.addAll(newPosts);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        isLoading = false;
        hasMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Reddit 포스트'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          controller: scrollController,
          itemCount: posts.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == posts.length) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: hasMore
                      ? const CircularProgressIndicator()
                      : const Text('모든 게시물을 불러왔습니다'),
                ),
              );
            }

            final post = posts[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '추천수: ${post.score} • 댓글: ${post.numComments}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(post: post),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class RedditPost {
  final String id;
  final String title;
  final String selfText;
  final int score;
  final int numComments;
  final String author;
  final String permalink;

  RedditPost({
    required this.id,
    required this.title,
    required this.selfText,
    required this.score,
    required this.numComments,
    required this.author,
    required this.permalink,
  });

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    return RedditPost(
      id: json['id'],
      title: json['title'],
      selfText: json['selftext'] ?? '',
      score: json['score'],
      numComments: json['num_comments'],
      author: json['author'],
      permalink: json['permalink'],
    );
  }
}