import 'package:gamjatuigimdit/shared/domain/models/post/post_model.dart';

class PostResponse {
  final List<Post> posts;
  final String? nextPageId;

  PostResponse({required this.posts, this.nextPageId});
}