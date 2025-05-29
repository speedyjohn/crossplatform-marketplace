import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/comment.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({
    Key? key,
    required this.comment,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    print('Building CommentItem for comment: ${comment.id}');
    print('Comment data: userName=${comment.userName}, text=${comment.text}, date=${comment.date}');
    
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  comment.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              Text(
                _formatDate(comment.date),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.text,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          if (comment.imageUrl != null) ...[
            const SizedBox(height: 8),
            Image.network(
              comment.imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image,
                size: 50,
              ),
            ),
          ],
        ],
      ),
    );
  }
} 