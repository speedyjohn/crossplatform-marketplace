import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> addToCart(Product product) async {
    if (_userId.isEmpty) return;

    final cartRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(product.id);

    await cartRef.set({
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFromCart(String productId) async {
    if (_userId.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  Future<void> clearCart() async {
    if (_userId.isEmpty) return;

    final cartSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .get();

    final batch = _firestore.batch();
    for (var doc in cartSnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<List<CartItem>> getCartItems() {
    if (_userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('cart')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CartItem(
          id: doc.id,
          productId: data['productId'] as String,
          name: data['name'] as String,
          price: (data['price'] as num).toDouble(),
          imageUrl: data['imageUrl'] as String,
          addedAt: (data['addedAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}

class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.addedAt,
  });
} 