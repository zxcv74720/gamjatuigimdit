import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    @Default('') String id,
    @Default('') String title,
    @JsonKey(name: 'selftext') @Default('') String selfText,
    @Default(0) int score,
    @JsonKey(name: 'num_comments') @Default(0) int numComments,
    @Default('') String author,
    @Default('') String permalink,
    String? url,
    String? thumbnail,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json);
}