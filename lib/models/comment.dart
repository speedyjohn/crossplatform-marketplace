class Comment {
  final String userName;
  final String text;
  final String date;
  final String? imageUrl;

  Comment({
    required this.userName,
    required this.text,
    required this.date,
    this.imageUrl,
  });
}