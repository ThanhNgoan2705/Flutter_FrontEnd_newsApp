import 'package:flutter_news_app/models/user.dart';

class Like {
  final String? id;
  final String? authorId;
  final String? postId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  Like({
    this.id,
    this.authorId,
    this.postId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'] as String?,
      authorId: json['authorId'] as String?,
      postId: json['postId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['authorId '] = authorId;
    data['postId'] = postId;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['user'] = user?.toJson();
    return data;
  }
}
