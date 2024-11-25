import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gamjatuigimdit/features/post_detail/domain/repositories/post_detail_repository.dart';
import 'package:gamjatuigimdit/features/post_detail/presentation/providers/state/post_detail_state.dart';
import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart';

class PostDetailNotifier extends StateNotifier<PostDetailState> {
  final PostDetailRepository _repository;
  final Post post;

  PostDetailNotifier(this._repository, this.post) : super(PostDetailState()) {
    loadComments();
  }

  Future<void> loadComments() async {
    state = state.copyWith(isLoading: true);

    final result = await _repository.getComments(post.permalink);

    result.fold(
          (failure) => state = state.copyWith(
        error: failure.message,
        isLoading: false,
      ),
          (comments) => state = state.copyWith(
        comments: comments,
        isLoading: false,
      ),
    );
  }
}