// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_news_app/models/category.dart';
import 'package:flutter_news_app/models/comment.dart';
import 'package:flutter_news_app/models/like.dart';
import 'package:flutter_news_app/models/user.dart';

class Post {
  final String? id;
  final String? title;
  final String? description;
  final String? image;
  final String? link;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userId;
  final String? categoryId;
  final List<Comment>? comments;
  final List<Like>? likes;
  final User? author;
  final Category? category;

  Post({
    this.id,
    this.title,
    this.description,
    this.image,
    this.link,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.categoryId,
    this.comments,
    this.likes,
    this.author,
    this.category,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      link: json['link'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String?,
      categoryId: json['categoryId'] as String?,
      comments: json['comments'] != null
          ? (json['comments'] as List<dynamic>)
              .map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      likes: json['likes'] != null
          ? (json['likes'] as List<dynamic>)
              .map((e) => Like.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      author: json['author'] != null
          ? User.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['link'] = link;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['userId'] = userId;
    data['categoryId'] = categoryId;
    data['comments'] = comments?.map((e) => e.toJson()).toList();
    data['likes'] = likes?.map((e) => e.toJson()).toList();
    data['author'] = author?.toJson();
    data['category'] = category?.toJson();
    return data;
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, description: $description, image: $image, link: $link, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, categoryId: $categoryId, comments: $comments, likes: $likes, author: $author, category: $category)';
  }
}
