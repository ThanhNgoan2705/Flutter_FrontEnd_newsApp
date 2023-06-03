import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/commoms/big_card_news.dart';
import 'package:flutter_news_app/commoms/small_card_news.dart';
import 'package:flutter_news_app/constant.dart';
import 'package:flutter_news_app/models/category.dart';
import 'package:flutter_news_app/models/post.dart';
import 'package:flutter_news_app/pages/news_by_category.dart';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Category> categories = [];

  List<Post> breakingNews = [];

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
    breakingNews = await getBreakingNews();
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Tin tức',
          style: textTheme.headlineLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<void>(
          future: init(),
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
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // list category
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        for (Category category in categories)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                              left: 4,
                              top: 4,
                              bottom: 4,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.alphaBlend(
                                  colorScheme.primary.withOpacity(0.3),
                                  Colors.white,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsByCategory(
                                            category: category)));
                              },
                              child: Text(
                                category.name ?? '',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  // list random news
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
                  // list breaking news
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tin nổi bật',
                      style: textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Divider(),
                  // list breaking news
                  Column(
                    children: [
                      for (Post post in breakingNews)
                        SmallCardNews(
                          post: post,
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
