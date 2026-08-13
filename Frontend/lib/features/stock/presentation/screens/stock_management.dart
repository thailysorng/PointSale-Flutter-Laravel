import 'package:flutter/material.dart' hide SearchBar;
import 'package:point_sale/features/products/providers/product_inventory_provider.dart';
import 'package:provider/provider.dart';

import 'package:point_sale/features/stock/presentation/widgets/search_bar.dart';
import 'package:point_sale/features/stock/presentation/widgets/category_filters.dart';
import 'package:point_sale/features/stock/presentation/widgets/stock_item_card.dart';
import 'package:point_sale/features/stock/presentation/widgets/summary_card.dart';
import 'package:point_sale/features/stock/presentation/widgets/status_filters.dart';
import 'package:point_sale/features/stock/presentation/widgets/low_stock_alert.dart';
import 'package:point_sale/core/theme/app_colors.dart';
import 'package:point_sale/core/widgets/app_drawer.dart';

class StockManagementView extends StatelessWidget {
  const StockManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<ProductInventoryProvider>();

    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: AppColors.background,
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.menu, color: Color(0xFF4A5565), size: 24),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        title: const Text(
          'Stock Management',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 20,
            color: Color(0xFF4A5565),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: Color(0xFF4A5565), size: 24),
            onPressed: () {
              // TODO: Implement export functionality
            },
          ),
        ],
      ),
      body: stock.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: stock.loadProducts,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SearchBar(
                    value: stock.stockSearchQuery,
                    onChanged: stock.setStockSearchQuery,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Low Stock',
                          value: stock.lowStockCount.toString(),
                          icon: Icons.warning_amber_rounded,
                          iconColor: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Value',
                          value: '\$${stock.totalStockValue.toStringAsFixed(2)}',
                          icon: Icons.inventory_2_outlined,
                          iconColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CategoryFilters(
                    categories: stock.categoryNames,
                    selected: stock.stockSelectedCategory ?? 'All',
                    onSelect: stock.selectStockCategory,
                  ),
                  const SizedBox(height: 16),
                  StatusFilters(
                    statuses: const [
                      'All Items',
                      'Low Stock',
                      'Normal',
                      'Well Stocked'
                    ],
                    selected: stock.stockSelectedStatus,
                    onSelect: stock.setStockStatus,
                  ),
                  const SizedBox(height: 16),
                  LowStockAlert(
                    lowStockCount: stock.lowStockCount,
                    onRestockAll: stock.restockAllLow,
                  ),
                  const SizedBox(height: 16),
                  ...stock.stockFilteredProducts.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: StockItemCard(
                        item: item,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
