import 'package:flutter/material.dart';
import 'package:point_sale/features/products/providers/product_inventory_provider.dart';
import 'package:provider/provider.dart';
import 'package:point_sale/core/widgets/app_drawer.dart';
import 'package:point_sale/features/products/data/models/product_model.dart';
import 'package:point_sale/features/cart/providers/cart_provider.dart';
import 'package:point_sale/features/products/presentation/widgets/product_card.dart';
import 'package:point_sale/features/cart/presentation/screens/cart_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductInventoryProvider>().products;

    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFF9FAFB),
              drawer: AppDrawer(),
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.black.withOpacity(0.1),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(color: const Color(0xFFE5E7EB), height: 1),
                ),
                leading: Builder(
                  builder: (context) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.menu,
                        color: Color(0xFF4A5565),
                        size: 24,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ),
                title: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 20,
                    color: Color(0xFF4A5565),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Stack(
                          clipBehavior: Clip.none, // Allow overflow
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00B8DB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            if (cart.totalItems > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE7000B),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${cart.totalItems}',
                                      style: const TextStyle(
                                        fontFamily: 'Arimo',
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        height: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A5565).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search Bar
                          Container(
                            height: 42.296,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFD1D5DC),
                                width: 1.15,
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search products...',
                                hintStyle: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 16,
                                  color: const Color(
                                    0xFF0A0A0A,
                                  ).withOpacity(0.5),
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 20,
                                  color: Color(0xFF6A7282),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Section Title
                          const Text(
                            'AVAILABLE PRODUCTS',
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 14,
                              color: Color(0xFF6A7282),
                              letterSpacing: 0.35,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Product Grid
                          Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    mainAxisExtent: 220,
                                  ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                // Get quantity from cart
                                final cartIndex = cart.items.indexWhere(
                                  (item) => item.product.id == product.id,
                                );

                                final cartQuantity = cartIndex != -1
                                    ? cart.items[cartIndex].quantity
                                    : 0;

                                return ProductCard(
                                  product: product,
                                  cartQuantity: cartQuantity,
                                  onAddPressed: () {
                                    final success = cart.addProduct(product);
                                    if (!success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Cannot add more. Out of stock!')),
                                      );
                                    }
                                  },
                                  onIncrement: () {
                                    final success = cart.incrementQuantity(product.id);
                                    if (!success) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Cannot add more. Out of stock!')),
                                      );
                                    }
                                  },
                                  onDecrement: () {
                                    cart.decrementQuantity(product.id);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Floating View Cart Button
            if (cart.totalItems > 0)
              Positioned(
                bottom: 75,
                left: 0,
                right: 0,
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 53,
                        padding: const EdgeInsets.only(left: 24, right: 0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B8DB),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                              spreadRadius: -3,
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'View Cart',
                                  style: TextStyle(
                                    fontFamily: 'Arimo',
                                    fontSize: 14,
                                    color: Colors.white,
                                    height: 1.43,
                                  ),
                                ),
                                Text(
                                  '${cart.totalItems} items',
                                  style: const TextStyle(
                                    fontFamily: 'Arimo',
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
