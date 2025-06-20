class Quote {
  String author;
  String text;

  Quote({required this.author, required this.text});

  Map<String, dynamic> toMap() {
    return {'author': author, 'text': text};
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(author: map['author'], text: map['text']);
  }
}
