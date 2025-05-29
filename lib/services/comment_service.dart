import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'comments';

  Future<List<Comment>> getCommentsForProduct(String productId) async {
    try {
      print('Fetching comments from Firestore for product: $productId');
      
      if (productId.isEmpty) {
        print('Error: Product ID is empty');
        return [];
      }

      // First, let's check if the collection exists and has any documents
      final collectionSnapshot = await _firestore.collection(_collection).get();
      print('Total documents in collection: ${collectionSnapshot.docs.length}');
      
      // Print all documents in collection for debugging
      for (var doc in collectionSnapshot.docs) {
        print('Document in collection: ${doc.id} - ${doc.data()}');
      }

      // Modified query to work without composite index
      final snapshot = await _firestore
          .collection(_collection)
          .where('productId', isEqualTo: productId)
          .get();

      print('Filtered documents for product $productId: ${snapshot.docs.length}');
      
      // Sort comments in memory instead of in the query
      final comments = snapshot.docs.map((doc) {
        final data = doc.data();
        print('Processing document ${doc.id} with data: $data');
        
        // Ensure all required fields are present
        if (data['userName'] == null || data['text'] == null || data['date'] == null || data['productId'] == null) {
          print('Warning: Document ${doc.id} is missing required fields');
          print('Available fields: ${data.keys.join(', ')}');
          return null;
        }
        
        try {
          final comment = Comment.fromMap(doc.id, data);
          print('Successfully created comment: ${comment.id} - ${comment.text}');
          return comment;
        } catch (e) {
          print('Error converting document ${doc.id}: $e');
          return null;
        }
      })
      .where((comment) => comment != null)
      .cast<Comment>()
      .toList();
      
      // Sort comments by date in descending order
      comments.sort((a, b) => b.date.compareTo(a.date));
      
      print('Successfully converted to ${comments.length} Comment objects');
      return comments;
    } catch (e) {
      print('Error getting comments: $e');
      return [];
    }
  }

  Future<void> addComment(Comment comment) async {
    try {
      if (comment.productId.isEmpty) {
        throw Exception('Product ID cannot be empty');
      }

      print('Adding comment to Firestore: ${comment.toMap()}');
      final docRef = await _firestore.collection(_collection).add(comment.toMap());
      print('Comment added successfully with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _firestore.collection(_collection).doc(commentId).delete();
    } catch (e) {
      print('Error deleting comment: $e');
      rethrow;
    }
  }
} 