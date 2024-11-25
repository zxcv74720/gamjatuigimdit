import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/post_list/domain/repositories/post_list_repository.dart';
import 'package:gamjatuigimdit/features/post_list/presentation/providers/state/post_list_state.dart';

class PostListNotifier extends StateNotifier<PostListState> {
  final PostListRepository postListRepository;

  PostListNotifier(this.postListRepository) : super(const PostListState());


  Future<void> fetchPosts({bool refresh = false}) async {
    if (state.isLoading) return;

    if (refresh) {
      state = const PostListState(isLoading: true, status: PostStatus.loading);
    } else {
      state = state.copyWith(isLoading: true);
    }

    final result = await postListRepository.getPosts(
        after: refresh ? null : state.nextPageId
    );

    result.fold(
          (failure) => state = state.copyWith(
        isLoading: false,
        status: PostStatus.error,
        errorMessage: failure.message,
      ),
          (response) => state = state.copyWith(
        posts: refresh
            ? response.posts
            : [...state.posts, ...response.posts],
        nextPageId: response.nextPageId,
        isLoading: false,
        status: PostStatus.loaded,
      ),
    );
  }
}
