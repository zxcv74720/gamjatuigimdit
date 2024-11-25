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
      backgroundColor: const Color.fromARGB(255, 95, 201, 248),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: state.isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white)) : RefreshIndicator(
        onRefresh: _refresh,
        color: const Color.fromARGB(255, 95, 201, 248),
        child: ListView.builder(
          controller: scrollController,
          itemCount: state.posts.length + (state.nextPageId != null ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.posts.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            }

            final post = state.posts[index];
            return Card(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title.split('\n')[0],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.title.split('\n')[1],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ],
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
              ),
            );
          },
        ),
      ),
    );
  }
}