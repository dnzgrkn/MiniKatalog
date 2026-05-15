import 'package:flutter/material.dart';
import '../models/product.dart';

/// Sepet ekranı — sepetteki ürünleri listeler, adet kontrolü ve toplam tutar sunar.
class CartScreen extends StatefulWidget {
  final List<Product> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Product> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.cartItems);
  }

  double get _total =>
      _items.fold(0.0, (sum, p) => sum + p.price * p.quantity);

  String get _formattedTotal {
    final whole = _total.truncate();
    final cents = ((_total - whole) * 100).round();
    final wholeStr = whole.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (m) => '${m[1]}.',
        );
    return '$wholeStr,${cents.toString().padLeft(2, '0')} ₺';
  }

  void _increment(int index) {
    setState(() {
      _items[index] =
          _items[index].copyWith(quantity: _items[index].quantity + 1);
    });
  }

  void _decrement(int index) {
    if (_items[index].quantity > 1) {
      setState(() {
        _items[index] =
            _items[index].copyWith(quantity: _items[index].quantity - 1);
      });
    } else {
      _removeItem(index);
    }
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _items);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sepetim'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _items),
          ),
        ),
        body: _items.isEmpty
            ? const Center(
                child: Text(
                  'Sepetiniz boş.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _items.length,
                itemBuilder: (context, index) => _buildCartItem(index),
              ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final p = _items[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Ürün resmi
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Image.asset(p.imagePath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            // Ürün bilgileri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.formattedPrice,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Adet kontrolü + sil
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeItem(index),
                  visualDensity: VisualDensity.compact,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 16),
                        onPressed: () => _decrement(index),
                        visualDensity: VisualDensity.compact,
                      ),
                      SizedBox(
                        width: 28,
                        child: Text(
                          '${p.quantity}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: () => _increment(index),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Toplam Tutar:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  _formattedTotal,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _items.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Siparişiniz alındı! Teşekkürler.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Alışverişi Tamamla',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
