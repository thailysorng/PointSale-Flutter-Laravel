import 'package:flutter/material.dart';
import 'package:point_sale/core/constants/app_color.dart';
import 'package:point_sale/features/orders/providers/order_provider.dart';
import 'package:point_sale/features/products/providers/product_inventory_provider.dart';
import 'package:provider/provider.dart';

class PaymentMethodModal extends StatefulWidget {
  final double subtotal;
  final double tax;
  final double totalAmount;
  final List<Map<String, dynamic>> items;
  final String? customerName;

  const PaymentMethodModal({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.totalAmount,
    required this.items,
    this.customerName,
  });

  @override
  State<PaymentMethodModal> createState() => _PaymentMethodModalState();
}

class _PaymentMethodModalState extends State<PaymentMethodModal> {
  String selectedPaymentMethod = 'KHQR Code';
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.whiteWithOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 20,
                    color: AppColor.textPrimary,
                    height: 1.4,
                  ),
                ),
                InkWell(
                  onTap: isProcessing
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 36,
                    height: 36,
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Payment Methods
            Column(
              children: [
                // KHQR Code
                _buildPaymentOption(
                  icon: Icons.qr_code,
                  label: 'KHQR Code',
                  value: 'KHQR Code',
                ),
                const SizedBox(height: 12),
                // Cash
                _buildPaymentOption(
                  icon: Icons.money,
                  label: 'Cash',
                  value: 'Cash',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Amount to Pay
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.whiteWithOpacity(0.9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Amount to Pay',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 16,
                      color: AppColor.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    '\$${widget.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 24,
                      color: AppColor.primary,
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: isProcessing
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0A0A0A),
                        side: const BorderSide(
                          color: AppColor.borderMedium,
                          width: 1.15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Confirm Button
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isProcessing
                          ? null
                          : () async {
                              setState(() {
                                isProcessing = true;
                              });

                              try {
                                final orderProvider =
                                    context.read<OrderProvider>();
                                final success =
                                    await orderProvider.createOrder(
                                      items: widget.items,
                                      subtotal: widget.subtotal,
                                      tax: widget.tax,
                                      total: widget.totalAmount,
                                      paymentMethod: selectedPaymentMethod,
                                      customerName: widget.customerName,
                                    );

                                if (success != null && mounted) {
                                  // Refresh products to update stock levels
                                  context
                                      .read<ProductInventoryProvider>()
                                      .loadProducts();
                                  Navigator.pop(context, selectedPaymentMethod);
                                } else if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to create order: ${orderProvider.error}',
                                      ),
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    isProcessing = false;
                                  });
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.whiteWithOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Confirm Payment',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isSelected = selectedPaymentMethod == value;

    return InkWell(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00B8DB).withOpacity(0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00B8DB)
                : const Color(0xFFE5E7EB),
            width: 1.15,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: const Color(0xFF0A0A0A),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 16,
                  color: Color(0xFF0A0A0A),
                  height: 1.5,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                size: 20,
                color: Color(0xFF00B8DB),
              ),
          ],
        ),
      ),
    );
  }
}
