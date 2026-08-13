import 'package:flutter/material.dart';
import 'package:point_sale/features/products/data/models/product_inventory.dart';
import 'package:point_sale/features/stock/presentation/widgets/restock_modal.dart';

class StockItemCard extends StatelessWidget {
  final ProductInventory item;

  const StockItemCard({super.key, required this.item});

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
    final isLowStock = item.quantity < item.minStock;
    final stockPercentage = (item.quantity / item.maxStock).clamp(0.0, 1.0);
    final lastUpdated = item.updatedAt ?? item.createdAt;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isLowStock ? Colors.red.shade200 : const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A202C),
                  ),
                ),
                Icon(
                  isLowStock ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isLowStock ? Colors.red : Colors.green,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'SKU: ${item.skuCode ?? "N/A"}',
                  style: const TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 12,
                    color: Color(0xFF6A7282),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '•',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6A7282),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.category?.name ?? 'Uncategorized',
                  style: const TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 12,
                    color: Color(0xFF6A7282),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.history, size: 16, color: Color(0xFF6A7282)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Stock Level',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 12,
                color: Color(0xFF6A7282),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: stockPercentage,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isLowStock ? Colors.red : const Color(0xFF00B8D0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${item.quantity}/${item.maxStock}',
                  style: const TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A202C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Min: ${item.minStock}',
                  style: const TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 12,
                    color: Color(0xFF6A7282),
                  ),
                ),
                Text(
                  'Last restocked: ${_formatDate(lastUpdated)}',
                  style: const TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 12,
                    color: Color(0xFF6A7282),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => RestockModal(item: item),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: Text(
                  isLowStock ? 'Restock Now (Urgent)' : 'Add Stock',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLowStock ? Colors.red : const Color(0xFF00B8D0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}