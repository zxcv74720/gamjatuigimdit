class Comment {
  final String author;
  final String body;
  final int score;
  final List<Comment> replies;

  Comment({
    required this.author,
    required this.body,
    required this.score,
    this.replies = const [],
  });
}

