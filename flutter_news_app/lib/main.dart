import 'package:flutter/material.dart';
import 'package:flutter_news_app/data.dart';
import 'package:flutter_news_app/pages/home_page.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final AppData appData = AppData.instance;
  await appData.getUser();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' News App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    ),
  );
}
