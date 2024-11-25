import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    @Default('') String id,
    @Default('') String title,
    @Default('') String selfText,
    @Default(0) int score,
    @Default(0) int numComments,
    @Default('') String author,
    @Default('') String permalink,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}