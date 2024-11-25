import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/post_list/domain/providers/post_list_providers.dart';
import 'package:gamjatuigimdit/features/post_list/presentation/providers/state/post_list_notifier.dart';
import 'package:gamjatuigimdit/features/post_list/presentation/providers/state/post_list_state.dart';

final postListNotifierProvider =
StateNotifierProvider<PostListNotifier, PostListState>((ref) {
  final repository = ref.watch(postListRepositoryProvider);
  return PostListNotifier(repository)..fetchPosts();
});
