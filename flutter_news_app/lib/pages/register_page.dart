import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/constant.dart';
import 'package:flutter_news_app/data.dart';
import 'package:flutter_news_app/models/user.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final AppData appData = AppData.instance;
  Future<void> register(String email, String password, String username) async {
    // Perform registration logic here
    if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
      // Register the user or perform any other action
      final resq = await http.post(
        Uri.parse(
          '${Constant.baseUrl}/auth/register',
        ),
        body: {
          'email': email,
          'password': password,
          'username': username,
        },
      );

      final json = jsonDecode(resq.body);
      if (json['message'] != null) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(json['message'])));
        }
      } else {
        final user = User.fromJson(json['user']);
        appData.setUser(user);
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
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
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Tên đăng nhập',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text;
                String password = _passwordController.text;
                String username = _usernameController.text;
                register(email, password, username);
              },
              child: const Text('Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}
