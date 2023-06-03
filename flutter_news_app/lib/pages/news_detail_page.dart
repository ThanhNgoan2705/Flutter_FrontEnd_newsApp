// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/constant.dart';
import 'package:flutter_news_app/data.dart';

import 'package:flutter_news_app/models/comment.dart';
import 'package:flutter_news_app/models/like.dart';
import 'package:flutter_news_app/models/post.dart';
import 'package:http/http.dart' as http;

class NewsDetailPage extends StatefulWidget {
  final Post post;
  const NewsDetailPage({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  List<Comment> comments = [];

  List<Like> likes = [];
  bool isLiked = false;
  final AppData appData = AppData.instance;

  @override
  void initState() {
    super.initState();
    comments = widget.post.comments ?? [];
    likes = widget.post.likes ?? [];
    if (appData.user != null) {
      isLiked = likes.any((element) => element.authorId == appData.user!.id);
    }
  }

  Future<void> toggleLike() async {
    if (appData.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn cần đăng nhập để thích bài viết'),
        ),
      );
      return;
    }

    if (isLiked) {
      final like = likes.firstWhere(
          (element) => element.authorId == appData.user!.id,
          orElse: () => Like());
      if (like.id != null) {
        await http.delete(
          Uri.parse(
            '${Constant.baseUrl}/likes/${like.id}',
          ),
        );
        likes.removeWhere((element) => element.authorId == appData.user!.id);
      }
    } else {
      final resp = await http.post(
        Uri.parse(
          '${Constant.baseUrl}/likes',
        ),
        body: {
          'authorId': appData.user!.id,
          'postId': widget.post.id,
        },
      );
      final json = jsonDecode(resp.body);
      final like = Like.fromJson(json);
      likes.add(like);
    }
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức'),
      ),
      body: ListView(
        children: [
          Image(
            image: NetworkImage(widget.post.image ?? ''),
            width: double.infinity,
            height: 240,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.post.title ?? '',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Tác giả: ${widget.post.author?.name ?? ''}'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.post.description ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          //comment section
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bình luận',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 52,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/seed/picsum/200/300',
                    ),
                  ),
                  title: Text('Duy Anh'),
                  subtitle: Text('Tuyệt vời'),
                ),
              ),
            ],
          ),

          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Viết bình luận',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await toggleLike();
        },
        child: isLiked
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border),
      ),
    );
  }
}
