import 'package:flutter/material.dart';
import 'package:point_sale/features/products/data/models/product_inventory.dart';
import 'package:point_sale/features/products/presentation/widgets/product_form_dialog.dart';
import 'package:point_sale/features/products/providers/product_inventory_provider.dart';
import 'package:provider/provider.dart';

class ProductListCard extends StatelessWidget {
  final ProductInventory product;

  const ProductListCard({super.key, required this.product});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Never';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastUpdated = product.updatedAt ?? product.createdAt;
    // Determine colors based on status
    Color badgeColor;
    Color badgeTextColor;
    String text;

    switch (product.status) {
      case 'low_stock':
        text = 'Low Stock';
        badgeColor = const Color(0xFFFEF3C7); // Amber 100
        badgeTextColor = const Color(0xFFD97706); // Amber 600
        break;
      case 'out_of_stock':
        text = 'Out of Stock';
        badgeColor = const Color(0xFFFEE2E2); // Red 100
        badgeTextColor = const Color(0xFFDC2626); // Red 600
        break;
      case 'in_stock':
      default:
        text = 'In Stock';
        badgeColor = const Color(0xFFD1FAE5); // Emerald 100
        badgeTextColor = const Color(0xFF059669); // Emerald 600
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)), // Gray 100
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Name and Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827), // Gray 900
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Second row: SKU, Category and Last Updated
          Row(
            children: [
              Text('#', style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text(
                product.skuCode ?? '',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 8),
              Text('•', style: TextStyle(color: Colors.grey.shade400)),
              const SizedBox(width: 8),
              Icon(Icons.local_offer_outlined, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                product.category?.name ?? '',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const Spacer(),
              Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                _formatDate(lastUpdated),
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Bottom row: Price, Stock, Actions
          Row(
            children: [
              // Price block
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('\$', style: TextStyle(fontSize: 16, color: Color(0xFF00B8D0), fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Text(
                        product.price.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00B8D0), // Cyan price text
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(width: 32),
              
              // Stock block
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Available', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 16, color: Colors.grey.shade800),
                      const SizedBox(width: 4),
                      Text(
                        '${product.quantity}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(width: 20),
              
              // Max block
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Max', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.inventory, size: 16, color: Colors.grey.shade800),
                      const SizedBox(width: 4),
                      Text(
                        '${product.maxStock}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Action buttons
              Row(
                children: [
                  _buildIconButton(Icons.edit_outlined, const Color(0xFF00B8D0), () {
                    showDialog(
                      context: context,
                      builder: (context) => ProductFormDialog(productToEdit: product),
                    );
                  }),
                  const SizedBox(width: 12),
                  _buildIconButton(Icons.delete_outline, const Color(0xFFEF4444), () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final success = await Provider.of<ProductInventoryProvider>(context, listen: false).deleteProduct(product.id!);
                    if (!success) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Failed to delete product')),
                      );
                    }
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
