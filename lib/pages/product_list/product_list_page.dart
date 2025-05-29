import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product.dart';
import '../../services/product_storage_service.dart';
import '../../providers/connectivity_provider.dart';
import 'product_list_item.dart';
import 'product_list_error.dart';
import 'product_list_loading.dart';
import 'product_list_empty.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  bool _showInitialLoader = true;
  bool _hasError = false;
  bool _isRefreshing = false;
  late final ProductStorageService _productService;
  final TextEditingController _searchController = TextEditingController();
  SortOption _currentSort = SortOption.nameAsc;

  @override
  void initState() {
    super.initState();
    _initProductService();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showInitialLoader = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initProductService() async {
    final prefs = await SharedPreferences.getInstance();
    _productService = ProductStorageService(prefs: prefs);
    _loadProducts();
  }

  void _sortProducts() {
    setState(() {
      switch (_currentSort) {
        case SortOption.nameAsc:
          _filteredProducts.sort((a, b) => a.name.compareTo(b.name));
          break;
        case SortOption.nameDesc:
          _filteredProducts.sort((a, b) => b.name.compareTo(a.name));
          break;
        case SortOption.priceAsc:
          _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortOption.priceDesc:
          _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
      }
    });
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts = _products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _sortProducts();
    });
  }

  Future<void> _loadProducts() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
      if (!_showInitialLoader) {
        _isLoading = true;
      }
    });

    try {
      final products = await _productService.getProducts();
      if (mounted) {
        setState(() {
          _products = products;
          _filteredProducts = List.from(products);
          _sortProducts();
          _isLoading = false;
          _hasError = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _isRefreshing = false;
        });
      }
    }
  }

  Widget _buildHeader(bool isOnline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              if (isOnline)
                _isRefreshing
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _loadProducts,
                        tooltip: 'Refresh list',
                      )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'You are offline',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchProducts,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: _filterProducts,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<SortOption>(
                  value: _currentSort,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: SortOption.nameAsc,
                      child: Text(AppLocalizations.of(context)!.sortAZ),
                    ),
                    DropdownMenuItem(
                      value: SortOption.nameDesc,
                      child: Text(AppLocalizations.of(context)!.sortZA),
                    ),
                    DropdownMenuItem(
                      value: SortOption.priceAsc,
                      child: Text(AppLocalizations.of(context)!.sortAsc),
                    ),
                    DropdownMenuItem(
                      value: SortOption.priceDesc,
                      child: Text(AppLocalizations.of(context)!.sortDesc),
                    ),
                  ],
                  onChanged: (SortOption? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _currentSort = newValue;
                        _sortProducts();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showInitialLoader) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: ProductListLoading(isInitial: true),
      );
    }

    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        return Scaffold(
          body: Column(
            children: [
              _buildHeader(connectivity.isOnline),
              Expanded(
                child: _hasError
                    ? ProductListError(onRetry: _loadProducts)
                    : _isLoading
                        ? const ProductListLoading()
                        : _filteredProducts.isEmpty
                            ? const ProductListEmpty()
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: _filteredProducts.length,
                                itemBuilder: (context, index) {
                                  return ProductListItem(
                                    product: _filteredProducts[index],
                                    index: index,
                                  );
                                },
                              ),
              ),
            ],
          ),
        );
      },
    );
  }
}

