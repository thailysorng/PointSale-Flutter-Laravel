import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:point_sale/features/orders/data/models/order.dart';
import 'package:point_sale/features/orders/providers/order_provider.dart';

class OrderDetailsModal extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsModal({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Arimo',
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Order ID and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order ID', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    order.orderNumber, 
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              _buildBadge(order.status),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // Customer
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Text(
                order.customerName,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Date & Time
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Text(
                '${order.date} at ${order.time}',
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // Cost Summary wrapped in grey container
          Container(
            padding: const EdgeInsets.all(6.00),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Items', style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () => _showProductsModal(context, order),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F8FB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Text('${order.itemCount} products', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF00B8D0))),
                            const SizedBox(width: 4),
                            const Icon(Icons.more_vert, color: Color(0xFF00B8D0), size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                    Text('\$${order.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tax (10%)', style: TextStyle(color: Colors.grey)),
                    Text('\$${order.tax.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00B8D0))),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Make as Paid button (only for pending)
          if (order.status.toLowerCase() == 'pending') ...[
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () async {
                  final provider = Provider.of<OrderProvider>(context, listen: false);
                  await provider.markAsPaid(order.id);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF00B8D0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Mark as Paid', style: TextStyle(color: Color(0xFF00B8D0), fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          // Close button full width Cyan
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00B8D0), // Cyan 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String status) {
    Color bg;
    Color fg;
    IconData icon;
    
    switch (status.toLowerCase()) {
      case 'completed':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF10B981);
        icon = Icons.check_circle_outline;
        break;
      case 'pending':
        bg = const Color(0xFFFFEDD5);
        fg = const Color(0xFFF97316);
        icon = Icons.access_time;
        break;
      case 'cancelled':
      default:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFEF4444);
        icon = Icons.cancel_outlined;
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            status[0].toUpperCase() + status.substring(1),
            style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showProductsModal(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 12.00),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Arimo')),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                    child: order.items.isEmpty 
                      ? const Center(child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text('No item details available'),
                        ))
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: order.items.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = order.items[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: item.imageUrl != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              item.imageUrl!,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.image_not_supported, color: Colors.grey, size: 20),
                                            ),
                                          )
                                        : const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                                        Row(
                                          children: [
                                            Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 6.0),
                                              child: Icon(Icons.close, size: 12,),
                                            ),
                                            Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                ],
                              ),
                            );
                          },
                        ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B8D0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('Close', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
