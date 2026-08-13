import 'package:flutter/material.dart';
import 'package:point_sale/features/products/providers/product_inventory_provider.dart';
import 'package:provider/provider.dart';
import 'package:point_sale/features/cart/providers/cart_provider.dart';
import 'package:point_sale/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:point_sale/features/cart/presentation/widgets/customer_information_modal.dart';
import 'package:point_sale/features/cart/presentation/widgets/payment_method_modal.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? _customerName;

  void showSuccessToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Color(0xFF00D492),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 16,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00D492).withOpacity(0.75),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFE5F7FB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF4A5565)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Shopping Cart',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 20,
                    color: Color(0xFF0A0A0A),
                    height: 1.4,
                  ),
                ),
                Text(
                  '${cart.totalItems} items',
                  style: const TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 14,
                    color: Color(0xFF4A5565),
                    height: 1.43,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: const Color(0xFFE5E7EB), height: 1.15),
            ),
          ),
          body: Column(
            children: [
              // Cart Items
              Expanded(
                child: cart.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                size: 40,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Your cart is empty',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 20,
                                color: Color(0xFF0A0A0A),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Add some products to get started',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 16,
                                color: Color(0xFF4A5565),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00B8DB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Start Shopping',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: cart.items.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final cartItem = cart.items[index];
                          return CartItemCard(
                            product: cartItem.product,
                            cartQuantity: cartItem.quantity,
                            onIncrement: () {
                              final success = cart.incrementQuantity(cartItem.product.id);
                              if (!success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Cannot add more. Out of stock!')),
                                );
                              }
                            },
                            onDecrement: () {
                              cart.decrementQuantity(cartItem.product.id);
                            },
                            onRemove: () {
                              cart.removeItem(cartItem.product.id);
                            },
                          );
                        },
                      ),
              ),

              // Order Summary & Actions
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE5E7EB), width: 1.15),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 17, 16, 0),
                child: Column(
                  children: [
                    // Summary Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          // Subtotal
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 14,
                                  color: Color(0xFF4A5565),
                                  height: 1.43,
                                ),
                              ),
                              Text(
                                '\$${cart.subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 14,
                                  color: Color(0xFF0A0A0A),
                                  height: 1.43,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Tax
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tax (10%)',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 14,
                                  color: Color(0xFF4A5565),
                                  height: 1.43,
                                ),
                              ),
                              Text(
                                '\$${cart.tax.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 14,
                                  color: Color(0xFF0A0A0A),
                                  height: 1.43,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 9),
                          // Divider
                          const Divider(
                            color: Color(0xFFE5E7EB),
                            thickness: 1.15,
                            height: 1.15,
                          ),
                          const SizedBox(height: 9),
                          // Total
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 18,
                                  color: Color(0xFF0A0A0A),
                                  height: 1.56,
                                ),
                              ),
                              Text(
                                '\$${cart.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 20,
                                  color: Color(0xFF00B8DB),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Action Buttons
                    Column(
                      children: [
                        // Pay Now Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: cart.isEmpty
                                ? null
                                : () async {
                                    final cartItems = cart.items.map((item) => {
                                      'product_id': item.product.id,
                                      'quantity': item.quantity,
                                      'price': item.product.price,
                                      'name': item.product.name,
                                    }).toList();

                                    final result = await showDialog<String>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return PaymentMethodModal(
                                          subtotal: cart.subtotal,
                                          tax: cart.tax,
                                          totalAmount: cart.total,
                                          items: cartItems,
                                          customerName: _customerName,
                                        );
                                      },
                                    );

                                    if (result != null && mounted) {
                                      // Payment confirmed - clear cart and show toast
                                      cart.clearCart();
                                      showSuccessToast(
                                        context,
                                        'Order created and paid with $result',
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00B8DB),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.credit_card, size: 20),
                            label: const Text(
                              'Pay Now',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Save for Later Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: cart.isEmpty
                                ? null
                                : () async {
                                    final customerInfo =
                                        await showDialog<Map<String, String>>(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return const CustomerInformationModal();
                                          },
                                        );

                                    if (customerInfo != null &&
                                        mounted) {
                                      final nickname = customerInfo['nickname'];
                                      setState(() {
                                        _customerName = nickname;
                                      });
                                      if (nickname != null &&
                                          nickname.isNotEmpty) {
                                        showSuccessToast(
                                          context,
                                          'Customer info added for $nickname',
                                        );
                                      } else {
                                        showSuccessToast(
                                          context,
                                          'Customer information added',
                                        );
                                      }
                                    }
                                  },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFF3F4F6),
                              foregroundColor: const Color(0xFF101828),
                              side: const BorderSide(
                                color: Color(0xFFD1D5DC),
                                width: 1.15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.info_outline, size: 20),
                            label: const Text(
                              'Customer Information',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
