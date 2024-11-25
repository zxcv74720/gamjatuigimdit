import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/post_list/domain/repositories/post_list_repository.dart';
import 'package:gamjatuigimdit/features/post_list/presentation/providers/state/post_list_state.dart';
import 'package:gamjatuigimdit/shared/domain/models/either.dart';
import 'package:gamjatuigimdit/shared/domain/models/paginated_response.dart';
import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart';
import 'package:gamjatuigimdit/shared/exceptions/http_exception.dart';
import 'package:gamjatuigimdit/shared/globals.dart';

class PostListNotifier extends StateNotifier<PostListState> {
  final PostListRepository postListRepository;

  PostListNotifier(
    this.postListRepository,
  ) : super(const PostListState.initial());

  bool get isFetching =>
      state.state != PostListConcreteState.loading &&
      state.state != PostListConcreteState.fetchingMore;

  Future<void> fetchPosts() async {
    if (isFetching &&
        state.state != PostListConcreteState.fetchedAllPosts) {
      state = state.copyWith(
        state: state.page > 0
            ? PostListConcreteState.fetchingMore
            : PostListConcreteState.loading,
        isLoading: true,
      );

      final response = await postListRepository.fetchPosts(
          skip: state.page * POSTS_PER_PAGE);

      updateStateFromResponse(response);
    } else {
      state = state.copyWith(
        state: PostListConcreteState.fetchedAllPosts,
        message: 'No more posts available',
        isLoading: false,
      );
    }
  }

  void updateStateFromResponse(
      Either<AppException, PaginatedResponse<dynamic>> response) {
    response.fold((failure) {
      state = state.copyWith(
        state: PostListConcreteState.failure,
        message: failure.message,
        isLoading: false,
      );
    }, (data) {
      final postList = data.data.map((e) => Post.fromJson(e)).toList();

      final totalPosts = [...state.postList, ...postList];

      state = state.copyWith(
        postList: totalPosts,
        state: totalPosts.length == data.total
            ? PostListConcreteState.fetchedAllPosts
            : PostListConcreteState.loaded,
        hasData: true,
        message: totalPosts.isEmpty ? 'No post found' : '',
        page: totalPosts.length ~/ POSTS_PER_PAGE,
        total: data.total,
        isLoading: false,
      );
    });
  }

  void resetState() {
    state = const PostListState.initial();
  }
}
