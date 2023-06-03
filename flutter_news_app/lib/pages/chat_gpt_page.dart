import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/message.dart';
import 'package:http/http.dart' as http;

class ChatGptPage extends StatefulWidget {
  const ChatGptPage({Key? key}) : super(key: key);

  @override
  State<ChatGptPage> createState() => _ChatGptPageState();
}

class _ChatGptPageState extends State<ChatGptPage> {
  final header = {
    "Content-Type": "application/json",
    "endcoding": "utf-8",
    "Authorization":
        "Bearer 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",
  };
  final url = "https://api.openai.com/v1/chat/completions";

  final controller = TextEditingController();
  List<Message> messages = [];
  final scrollController = ScrollController();

  bool isLoading = false;

  Future<void> sendMessage(String text) async {
    messages.add(Message('user', text));
    setState(() {
      isLoading = true;
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
    setState(() {});
    final response = await http.post(
      Uri.parse(url),
      headers: header,
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": messages.map((e) => e.toJson()).toList()
      }),
    );

    Message newMessage = Message.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes))['choices'][0]['message']);
    messages.add(newMessage);

    setState(() {
      isLoading = false;
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat GPT'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                messages.clear();
              });
            },
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              children: [
                for (var item in messages)
                  if (item.role == 'user')
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          item.content,
                          maxLines: null,
                          softWrap: true,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          item.content,
                          maxLines: null,
                          softWrap: true,
                        ),
                      ),
                    ),
                if (isLoading)
                  const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () async {
                      await sendMessage(controller.text);
                      controller.clear();
                    },
                    icon: const Icon(Icons.send)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
