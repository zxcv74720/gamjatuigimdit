import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/post_list/data/repositories/post_list_repository_impl.dart';
import 'package:gamjatuigimdit/features/post_list/data/service/post_list_service.dart';
import 'package:gamjatuigimdit/features/post_list/domain/repositories/post_list_repository.dart';
import 'package:gamjatuigimdit/features/post_list/presentation/providers/state/post_list_notifier.dart';
import 'package:gamjatuigimdit/features/post_list/presentation/providers/state/post_list_state.dart';
import 'package:gamjatuigimdit/features/splash/domain/providers/token_providers.dart';

/// Service Provider
final postListServiceProvider = Provider<PostListService>((ref) {
  final token = ref.watch(tokenProvider);
  return PostListServiceImpl(token);
});

/// Repository Provider
final postListRepositoryProvider = Provider<PostListRepository>(
      (ref) => PostListRepositoryImpl(ref.watch(postListServiceProvider)),
);

/// State Notifier Provider
final postListNotifierProvider = StateNotifierProvider<PostListNotifier, PostListState>((ref) {
  final repository = ref.watch(postListRepositoryProvider);
  // 초기 데이터 로드를 위해 fetchPosts 호출
  return PostListNotifier(repository)..fetchPosts();
});