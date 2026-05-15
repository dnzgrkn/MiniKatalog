import 'package:flutter/material.dart';
import '../models/product.dart';

/// Product detail screen.
///
/// Demonstrates:
/// - Receiving data via constructor (Route Arguments — Day 3)
/// - StatefulWidget with multiple pieces of local state (Day 1, Day 5)
/// - Returning a result to the previous screen via Navigator.pop (Day 3)
/// - Composition of Row, Column, Padding, Container widgets (Day 2)
class DetailScreen extends StatefulWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;

  void _increment() {
    if (_quantity < 99) setState(() => _quantity++);
  }

  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  /// Pops back to the home screen with the chosen quantity.
  /// The home screen reads this value and updates its cart counter.
  void _addToCart() {
    Navigator.pop(context, _quantity);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(p),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryChip(p),
                  const SizedBox(height: 12),
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRatingRow(p),
                  const SizedBox(height: 16),
                  Text(
                    p.formattedPrice,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ürün Açıklaması',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (p.inStock) _buildQuantitySelector(),
                  const SizedBox(height: 100), // leave room for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(p),
    );
  }

  Widget _buildHeroImage(Product p) {
    return Container(
      width: double.infinity,
      height: 280,
      color: Colors.grey.shade100,
      child: Image.asset(p.imagePath, fit: BoxFit.contain),
    );
  }

  Widget _buildCategoryChip(Product p) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        p.category,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRatingRow(Product p) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const SizedBox(width: 4),
        Text(
          p.rating.toStringAsFixed(1),
          style:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 12),
        Container(width: 1, height: 14, color: Colors.grey.shade400),
        const SizedBox(width: 12),
        Text(
          p.inStock ? 'Stokta var' : 'Stokta yok',
          style: TextStyle(
            fontSize: 13,
            color: p.inStock ? Colors.green.shade700 : Colors.red.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text(
          'Adet:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrement,
                visualDensity: VisualDensity.compact,
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '$_quantity',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _increment,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(Product p) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shopping_cart),
            label: Text(
              p.inStock ? 'Sepete Ekle ($_quantity)' : 'Stokta Yok',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onPressed: p.inStock ? _addToCart : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
