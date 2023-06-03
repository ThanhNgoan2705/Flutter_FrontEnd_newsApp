import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/post.dart';
import 'package:flutter_news_app/pages/news_detail_page.dart';

class BigCardNews extends StatelessWidget {
  final Post post;
  const BigCardNews({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewsDetailPage(post: post)));
        },
        child: Stack(
          children: [
            Image(
              image: NetworkImage(post.image ?? ''),
              fit: BoxFit.fill,
              width: double.infinity,
            ),
            Positioned(
              top: 0.5,
              left: 0.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(
                      colorScheme.primary.withOpacity(0.7),
                      Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    post.category?.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  post.title ?? '',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
