import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';
import '../widgets/product_card.dart';
import 'detail_screen.dart';

/// Home screen showing the product grid.
///
/// Demonstrates:
/// - StatefulWidget with [setState] (Day 1)
/// - Loading data from a local JSON asset using rootBundle + jsonDecode (Day 4)
/// - ListView.builder vs GridView.builder (Day 4 / Day 5)
/// - Search filtering with TextField (Day 4)
/// - Navigator.push + receiving a result back via Navigator.pop (Day 3)
/// - Simple cart state update simulation (Day 5)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'Tümü';
  int _cartCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  /// Reads `assets/data/products.json` and parses it into [Product] objects.
  /// Uses only rootBundle + jsonDecode — no external packages.
  Future<void> _loadProducts() async {
    final raw = await rootBundle.loadString('assets/data/products.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = (decoded['products'] as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() {
      _allProducts = list;
      _isLoading = false;
    });
  }

  /// Filters products by search query and selected category.
  List<Product> get _filteredProducts {
    return _allProducts.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'Tümü' || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> get _categories {
    final set = {'Tümü', ..._allProducts.map((p) => p.category)};
    return set.toList();
  }

  /// Opens the detail screen and updates cart count from its return value.
  Future<void> _openDetail(Product product) async {
    final addedQuantity = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(product: product),
      ),
    );
    if (addedQuantity != null && addedQuantity > 0) {
      setState(() => _cartCount += addedQuantity);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sepete $addedQuantity ürün eklendi'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sepetinizde $_cartCount ürün var'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              if (_cartCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildBanner(),
                _buildSearchBar(),
                _buildCategoryChips(),
                Expanded(child: _buildProductGrid()),
              ],
            ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 3,
          child: Image.asset('assets/images/banner.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Ürün ara...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) =>
                  setState(() => _selectedCategory = category),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _filteredProducts;
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Aradığınız kriterlere uygun ürün bulunamadı.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => _openDetail(product),
        );
      },
    );
  }
}
