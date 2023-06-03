class Message {
  final String role;
  final String content;

  Message(this.role, this.content);

  Message.fromJson(Map<String, dynamic> json)
      : role = json['role'] as String,
        content = json['content'] as String;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['role'] = role;
    data['content'] = content;
    return data;
  }
}
