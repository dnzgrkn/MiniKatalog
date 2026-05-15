import 'package:flutter/material.dart';
import '../models/product.dart';

/// Reusable card widget for displaying a [Product] in the grid.
///
/// Wraps an image, name, price and category in a tappable Card.
/// Demonstrates how to extract repeated UI into reusable widgets.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Image area (uses Image.asset, per Day 4 requirement) ---
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(product.imagePath, fit: BoxFit.cover),
                  if (!product.inStock)
                    Container(
                      color: Colors.black54,
                      alignment: Alignment.center,
                      child: const Text(
                        'STOKTA YOK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // --- Text area ---
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.formattedPrice,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 13, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
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
