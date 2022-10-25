class Message {
  final String text;
  final DateTime createdAt;
  //final bool isSender;

  Message(
    this.text,
    this.createdAt,
  );

  Message.fromJson(Map<dynamic, dynamic> json)
      : createdAt = DateTime.parse(json['createdAt'] as String),
        text = json['text'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'createdAt': createdAt.toString(),
        'text': text.toString(),
      };
}
