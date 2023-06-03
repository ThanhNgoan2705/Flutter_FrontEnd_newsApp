import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/post.dart';
import 'package:flutter_news_app/pages/news_detail_page.dart';

class SmallCardNews extends StatelessWidget {
  final Post post;
  const SmallCardNews({Key? key, required this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (thisContext) => NewsDetailPage(post: post)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title ?? '',
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    post.description ?? '',
                    style: textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                image: NetworkImage(post.image ?? ''),
                width: 120,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
