class Comment {
  final String id;
  final String userName;
  final String text;
  final DateTime date;
  final String? imageUrl;
  final String productId;

  Comment({
    required this.id,
    required this.userName,
    required this.text,
    required this.date,
    required this.productId,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'text': text,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'productId': productId,
    };
  }

  factory Comment.fromMap(String id, Map<String, dynamic> map) {
    return Comment(
      id: id,
      userName: map['userName'] ?? '',
      text: map['text'] ?? '',
      date: DateTime.parse(map['date']),
      imageUrl: map['imageUrl'],
      productId: map['productId'] ?? '',
    );
  }
}