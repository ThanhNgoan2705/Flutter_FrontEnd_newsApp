import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/constant.dart';
import 'package:flutter_news_app/data.dart';
import 'package:flutter_news_app/models/user.dart';
import 'package:flutter_news_app/pages/home_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AppData appData = AppData.instance;

  Future<void> login(String email, String password) async {
    final resp = await http.post(
        Uri.parse(
          '${Constant.baseUrl}/auth/login',
        ),
        body: {
          'email': email,
          'password': password,
        });

    final json = jsonDecode(resp.body);
    if (json['message'] != null) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(json['message'])));
      }
    } else {
      final user = User.fromJson(json['user']);
      appData.setUser(user);
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'mật khẩu',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;
                // Perform login validation here
                if (email.isNotEmpty && password.isNotEmpty) {
                  // Navigate to the home page or perform any other action
                  await login(email, password);
                } else {
                  // Show snackbar if any field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng điền đầy đủ thông tin'),
                    ),
                  );
                }
              },
              child: const Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
