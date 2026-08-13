import 'package:flutter/material.dart';
import 'package:point_sale/features/products/data/models/product_inventory.dart';
import 'package:point_sale/core/constants/app_color.dart';

class ProductCard extends StatelessWidget {
  final ProductInventory product;
  final int cartQuantity;
  final VoidCallback onAddPressed;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductCard({
    super.key,
    required this.product,
    required this.cartQuantity,
    required this.onAddPressed,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    print('IMAGE URL: ${product.imageUrl}');
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteWithOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColor.borderMedium,
          width: 1.15,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Product Image
          if (product.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            )
          else
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          const SizedBox(height: 12),
          // Product Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              product.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Arimo',
                fontSize: 14,
                color: AppColor.textPrimary,
                height: 1.43,
              ),
            ),
          ),
          const SizedBox(height: 4),
          
          // Price
          Text(
            '\$${product.price.toStringAsFixed(product.price == product.price.roundToDouble() ? 0 : 2)}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Arimo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
              height: 1.5,
            ),
          ),
          const Spacer(flex: 1,),
          // Add Button or Quantity Control
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 36,
              child: cartQuantity > 0
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppColor.primary.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Decrement Button
                          InkWell(
                            onTap: onDecrement,
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: AppColor.whiteWithOpacity(0.95),
                              ),
                            ),
                          ),
                          // Quantity
                          Text(
                            '$cartQuantity',
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 16,
                              color: AppColor.whiteWithOpacity(0.95),
                              height: 1.5,
                            ),
                          ),
                          // Increment Button
                          InkWell(
                            onTap: onIncrement,
                            borderRadius: BorderRadius.circular(4),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child:  Icon(
                                Icons.add,
                                size: 16,
                                color: AppColor.whiteWithOpacity(0.95),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: onAddPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: AppColor.whiteWithOpacity(0.95),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 16,
                            color: AppColor.whiteWithOpacity(0.95),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Add',
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 14,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
