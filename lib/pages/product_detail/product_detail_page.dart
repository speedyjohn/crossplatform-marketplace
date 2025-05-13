import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/product.dart';
import '../../models/comment.dart';
import 'product_detail_header.dart';
import 'product_specs_table.dart';
import 'comment_item.dart';
import 'comment_input.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final int index;

  const ProductDetailPage({
    Key? key,
    required this.product,
    required this.index,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<Comment> _comments = [];
  final Map<String, String> _specs = {
    'Материал': 'Пластик',
    'Вес': '450 г',
    'Размеры': '20 × 15 × 5 см',
    'Цвет': 'Черный',
    'Гарантия': '1 год',
  };

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    setState(() {
      _comments = [
        Comment(
          userName: "Алексей",
          text: "Отличный товар, всем рекомендую!",
          date: "10.05.2023",
        ),
        Comment(
          userName: "Мария",
          text: "Качество на высоте, но дороговато",
          date: "15.05.2023",
        ),
      ];
    });
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.9),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: Hero(
                  tag: 'product-${widget.product.id}-${widget.index}',
                  child: Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      await _picker.pickImage(source: source);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _addComment() {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter text of the comment.')),
      );
      return;
    }

    final newComment = Comment(
      userName: "You",
      text: _commentController.text,
      date: "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
    );

    setState(() {
      _comments.insert(0, newComment);
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductDetailHeader(
              product: widget.product,
              index: widget.index,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  ProductSpecsTable(specs: _specs),
                  const SizedBox(height: 24),
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CommentInput(
                    controller: _commentController,
                    onSubmit: _addComment,
                    picker: _picker,
                  ),
                  const SizedBox(height: 16),
                  ..._comments.map((comment) => CommentItem(comment: comment)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}