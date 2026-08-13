import 'package:flutter/material.dart';
import 'package:point_sale/features/products/data/models/product_inventory.dart';
import 'package:point_sale/core/constants/app_color.dart';

class CartItemCard extends StatelessWidget {
  final ProductInventory product;
  final int cartQuantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.product,
    required this.cartQuantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final itemTotal = product.price * cartQuantity;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColor.whiteWithOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColor.borderMedium,
          width: 1.15,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackWithOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColor.blackWithOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColor.borderMedium,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: product.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.imageUrl!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, size: 24),
                        ),
                      )
                    : Center(
                        child: Text(
                          product.name[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.2,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 18,
                        color: AppColor.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 16,
                        color: AppColor.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Delete Button
              InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 36,
                  height: 36,
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.delete_outline,
                    color: AppColor.error,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bottom Row: Quantity Control & Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity Control
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.borderMedium,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    // Decrement Button
                    InkWell(
                      onTap: onDecrement,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.remove,
                          size: 16,
                          color: AppColor.textPrimary,
                        ),
                      ),
                    ),
                    // Quantity
                    SizedBox(
                      width: 32,
                      child: Center(
                        child: Text(
                          '$cartQuantity',
                          style: const TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 16,
                            color: AppColor.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    // Increment Button
                    InkWell(
                      onTap: onIncrement,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: AppColor.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Item Total
              Text(
                '\$${itemTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 18,
                  color: AppColor.textPrimary,
                  height: 1.56,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
