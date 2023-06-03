import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/commoms/big_card_news.dart';
import 'package:flutter_news_app/constant.dart';
import 'package:flutter_news_app/models/category.dart';
import 'package:flutter_news_app/models/post.dart';
import 'package:flutter_news_app/pages/news_by_category.dart';
import 'package:flutter_news_app/pages/search_delegate.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Category> categories = [];
  List<Post> ramdomNews = [];
  Future<List<Category>> getCategory() async {
    final url = Uri.parse('${Constant.baseUrl}/categories');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = resp.body;
      final json = jsonDecode(data);
      final categoriesJson = json as List<dynamic>;
      final categories = categoriesJson
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
      return categories;
    }
    return [];
  }

  Future<List<Post>> getBreakingNews() async {
    final url = Uri.parse('${Constant.baseUrl}/posts/breakingNews');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = resp.body;
      final json = jsonDecode(data);

      final postsJson = json as List<dynamic>;
      final breakingNews = postsJson
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();

      return breakingNews;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> init() async {
    categories = await getCategory();

    ramdomNews = await getRandom();
  }

  Future<List<Post>> getRandom() async {
    final url = Uri.parse('${Constant.baseUrl}/posts/hotNews');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = resp.body;
      final json = jsonDecode(data);
      final postsJson = json as List<dynamic>;
      final ramdomNews = postsJson
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
      return ramdomNews;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<void>(
          future: init(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tìm kiếm',
                      style: textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        showSearch(
                            context: context, delegate: MySearchDelegate());
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CarouselSlider(
                    items: [
                      for (Post post in ramdomNews)
                        BigCardNews(
                          post: post,
                        ),
                    ],
                    options: CarouselOptions(
                      height: 180,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Danh mục',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (Category category in categories)
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsByCategory(
                                  category: category,
                                ),
                              ),
                            );
                          },
                          title: Text(category.name ?? ''),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
