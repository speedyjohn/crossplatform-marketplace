import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../models/comment.dart';
import '../../services/comment_service.dart';
import '../../providers/AuthProvider.dart';
import '../../widgets/add_to_cart_button.dart';
import 'product_detail_header.dart';
import 'product_specs_table.dart';
import 'comment_item.dart';
import 'comment_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final CommentService _commentService = CommentService();
  List<Comment> _comments = [];
  bool _isLoading = true;
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
    print('ProductDetailPage initialized with product ID: ${widget.product.id}');
    _loadComments();
  }

  Future<void> _loadComments() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      print('Loading comments for product: ${widget.product.id}');
      final comments = await _commentService.getCommentsForProduct(widget.product.id);
      print('Loaded ${comments.length} comments');
      
      if (!mounted) return;
      
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading comments: $e');
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading comments: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
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

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter text of the comment.')),
      );
      return;
    }

    print('Creating new comment for product: ${widget.product.id}');
    print('Product details: name=${widget.product.name}, id=${widget.product.id}');

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userName = authProvider.user?.name ?? 'Guest';

    final newComment = Comment(
      id: '', // Will be set by Firestore
      userName: userName,
      text: _commentController.text,
      date: DateTime.now(),
      productId: widget.product.id,
    );

    print('New comment data: ${newComment.toMap()}');

    try {
      print('Adding comment to Firestore...');
      await _commentService.addComment(newComment);
      _commentController.clear();
      print('Comment added successfully, reloading comments...');
      
      // Add a small delay to ensure Firestore has updated
      await Future.delayed(const Duration(milliseconds: 500));
      await _loadComments(); // Reload comments after adding
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment added successfully')),
        );
      }
    } catch (e) {
      print('Error adding comment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding comment: $e')),
        );
      }
    }
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
                  const SizedBox(height: 16),
                  AddToCartButton(
                    product: widget.product,
                    onAdded: () {
                      // Optional: Add any additional logic when product is added to cart
                    },
                  ),
                  const SizedBox(height: 24),
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
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_comments.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations.of(context)!.commentsEmpty,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        return CommentItem(comment: _comments[index]);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}