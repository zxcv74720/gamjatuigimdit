import 'package:gamjatuigimdit/shared/domain/models/comment/comment.dart';

class PostDetailState {
  final bool isLoading;
  final List<Comment> comments;
  final String? error;

  PostDetailState({
    this.isLoading = true,
    this.comments = const [],
    this.error,
  });

  PostDetailState copyWith({
    bool? isLoading,
    List<Comment>? comments,
    String? error,
  }) {
    return PostDetailState(
      isLoading: isLoading ?? this.isLoading,
      comments: comments ?? this.comments,
      error: error ?? this.error,
    );
  }
}