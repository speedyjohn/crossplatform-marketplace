import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProductStorageService {
  static const String _productsKey = 'cached_products';
  final SharedPreferences _prefs;
  final FirebaseFirestore _firestore;
  final Connectivity _connectivity;

  ProductStorageService({
    required SharedPreferences prefs,
    FirebaseFirestore? firestore,
    Connectivity? connectivity,
  }) : _prefs = prefs,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _connectivity = connectivity ?? Connectivity();

  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<List<Product>> getProducts() async {
    final hasConnection = await hasInternetConnection();
    
    if (hasConnection) {
      try {
        final snapshot = await _firestore.collection('products').get();
        final products = snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
        
        // Cache products locally
        await _cacheProducts(products);
        return products;
      } catch (e) {
        // If there's an error fetching from Firebase, fall back to cached data
        return _getCachedProducts();
      }
    } else {
      // No internet connection, use cached data
      return _getCachedProducts();
    }
  }

  Future<void> _cacheProducts(List<Product> products) async {
    final productsJson = products.map((product) => {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'details': product.details,
    }).toList();
    
    await _prefs.setString(_productsKey, jsonEncode(productsJson));
  }

  List<Product> _getCachedProducts() {
    final cachedData = _prefs.getString(_productsKey);
    if (cachedData == null) {
      return [];
    }

    try {
      final List<dynamic> productsJson = jsonDecode(cachedData);
      return productsJson.map((json) => Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'],
        details: json['details'] != null ? List<String>.from(json['details']) : null,
      )).toList();
    } catch (e) {
      return [];
    }
  }
} 