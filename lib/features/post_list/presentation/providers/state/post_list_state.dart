import 'package:equatable/equatable.dart';
import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart';

enum PostListConcreteState {
  initial,
  loading,
  loaded,
  failure,
  fetchingMore,
  fetchedAllPosts
}

class PostListState extends Equatable {
  final List<Post> postList;
  final int total;
  final int page;
  final bool hasData;
  final PostListConcreteState state;
  final String message;
  final bool isLoading;
  const PostListState({
    this.postList = const [],
    this.isLoading = false,
    this.hasData = false,
    this.state = PostListConcreteState.initial,
    this.message = '',
    this.page = 0,
    this.total = 0,
  });

  const PostListState.initial({
    this.postList = const [],
    this.total = 0,
    this.page = 0,
    this.isLoading = false,
    this.hasData = false,
    this.state = PostListConcreteState.initial,
    this.message = '',
  });

  PostListState copyWith({
    List<Post>? postList,
    int? total,
    int? page,
    bool? hasData,
    PostListConcreteState? state,
    String? message,
    bool? isLoading,
  }) {
    return PostListState(
      isLoading: isLoading ?? this.isLoading,
      postList: postList ?? this.postList,
      total: total ?? this.total,
      page: page ?? this.page,
      hasData: hasData ?? this.hasData,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'PostListState(isLoading:$isLoading, postList: ${postList.length},total:$total page: $page, hasData: $hasData, state: $state, message: $message)';
  }

  @override
  List<Object?> get props => [postList, page, hasData, state, message];
}
