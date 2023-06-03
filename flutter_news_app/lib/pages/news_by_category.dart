// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/commoms/big_card_news.dart';
import 'package:flutter_news_app/constant.dart';

import 'package:flutter_news_app/models/category.dart';
import 'package:flutter_news_app/pages/search_delegate.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class NewsByCategory extends StatelessWidget {
  final Category category;
  const NewsByCategory({
    Key? key,
    required this.category,
  }) : super(key: key);

  Future<List<Post>> getPostsByCategory(String categoryiId) async {
    print('${Constant.baseUrl}/posts/category/$categoryiId');
    final resp = await http
        .get(Uri.parse('${Constant.baseUrl}/posts/category/$categoryiId'));

    if (resp.statusCode == 200) {
      final data = resp.body;
      final json = jsonDecode(data);

      final postsJson = json as List<dynamic>;
      final posts = postsJson
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();

      return posts;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              category.name ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<Post>>(
                future: getPostsByCategory(category.id ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Có lỗi xảy ra'),
                    );
                  }

                  final posts = snapshot.data!;
                  if (posts.isEmpty) {
                    return const Center(
                      child: Text('Không có dữ liệu'),
                    );
                  }
                  return ListView(
                    children: [
                      for (Post post in posts)
                        SizedBox(height: 240, child: BigCardNews(post: post)),
                      // for (Post post in posts)
                      //   SmallCardNews(post: post),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
