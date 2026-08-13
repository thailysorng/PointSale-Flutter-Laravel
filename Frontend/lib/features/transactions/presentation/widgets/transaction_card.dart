import 'package:flutter/material.dart';
import 'package:point_sale/features/transactions/data/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  // <-- Helper to format amounts with $ and negative as -$
  String formatCurrency(double value) {
    if (value < 0) {
      return '-\$${value.abs().toStringAsFixed(2)}';
    }
    return '+\$${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Card background
        borderRadius: BorderRadius.circular(12), // Rounded corners
        border: Border.all(
          color: Colors.grey.shade300, // Stroke color, like ChoiceChip
          width: 1, // Stroke thickness
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      transaction.transactionNumber ?? 'TXN-${transaction.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildTypeChip(transaction.type),
                  ],
                ),
                Text(
                  formatCurrency(transaction.amount),
                  style: TextStyle(
                    color: transaction.amount > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(transaction.description),
            const SizedBox(height: 8),
            Row(
              children: [
                _getPaymentIcon(transaction.paymentMethod),
                const SizedBox(width: 8),
                Text(transaction.paymentMethod),
                const SizedBox(width: 16),
                Text('${transaction.date} ${transaction.time}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPaymentIcon(String paymentMethod) {
    switch (paymentMethod) {
      case 'Card':
        return const Icon(Icons.credit_card, size: 16);
      case 'Cash':
        return const Icon(Icons.money, size: 16);
      case 'Digital':
        return const Icon(Icons.phonelink_ring, size: 16);
      default:
        return const Icon(Icons.payment, size: 16);
    }
  }

  Widget _buildTypeChip(String type) {
    Color color = Colors.green;
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          'Sale',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
