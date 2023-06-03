import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/commoms/small_card_news.dart';
import 'package:flutter_news_app/constant.dart';
import 'package:flutter_news_app/models/post.dart';
import 'package:http/http.dart' as http;

class MySearchDelegate extends SearchDelegate {
  final List<Post> _results = [];

  Future<void> getPost() async {
    final url = Uri.parse('${Constant.baseUrl}/posts/search/${query.trim()}');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = resp.body;
      final json = jsonDecode(data);
      final postsJson = json as List<dynamic>;
      final posts = postsJson
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
      _results.clear();
      _results.addAll(posts);
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _results.clear();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        query = '';
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<void>(
      future: getPost(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: _results.length,
          itemBuilder: (context, index) {
            return SmallCardNews(post: _results[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.search),
          title: Text('Tìm với từ khoá $query'),
          onTap: () {
            query.isEmpty ? null : close(context, query);
          },
        )
      ],
    );
  }
}
