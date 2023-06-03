import 'package:flutter_news_app/models/user.dart';

class Comment {
  final String? id;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? authorId;
  final String? postId;
  final User? author;

  Comment({
    this.id,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.authorId,
    this.postId,
    this.author,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'] as String?,
        content: json['content'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        authorId: json['authorId'] as String?,
        postId: json['postId'] as String?,
        author: json['author'] != null
            ? User.fromJson(json['author'] as Map<String, dynamic>)
            : null);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['authorId'] = authorId;
    data['postId'] = postId;
    data['author'] = author?.toJson();
    return data;
  }
}
