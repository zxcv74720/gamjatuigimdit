// post_list_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/post_list/presentation/providers/post_list_state_provider.dart';
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

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    _fetchInitialPosts();
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.8) {
      _loadMorePosts();
    }
  }

  Future<void> _fetchInitialPosts() async {
    ref.read(postListNotifierProvider.notifier).fetchPosts();
  }

  Future<void> _loadMorePosts() async {
    final state = ref.read(postListNotifierProvider);
    if (!state.isLoading && state.nextPageId != null) {
      ref.read(postListNotifierProvider.notifier).fetchPosts();
    }
  }

  Future<void> _refresh() async {
    ref.read(postListNotifierProvider.notifier).fetchPosts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Reddit 포스트'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          controller: scrollController,
          itemCount: state.posts.length + (state.nextPageId != null ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.posts.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final post = state.posts[index];
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