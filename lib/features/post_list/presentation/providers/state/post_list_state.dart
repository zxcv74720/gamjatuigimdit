import 'package:equatable/equatable.dart';
import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart';

enum PostStatus { initial, loading, loaded, error }

class PostListState extends Equatable {
  final List<Post> posts;
  final String? nextPageId;
  final bool isLoading;
  final PostStatus status;
  final String? errorMessage;

  const PostListState({
    this.posts = const [],
    this.nextPageId,
    this.isLoading = false,
    this.status = PostStatus.initial,
    this.errorMessage,
  });

  PostListState copyWith({
    List<Post>? posts,
    String? nextPageId,
    bool? isLoading,
    PostStatus? status,
    String? errorMessage,
  }) {
    return PostListState(
      posts: posts ?? this.posts,
      nextPageId: nextPageId ?? this.nextPageId,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [posts, nextPageId, isLoading, status, errorMessage];
}
