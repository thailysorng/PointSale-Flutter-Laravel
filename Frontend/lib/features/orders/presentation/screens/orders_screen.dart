import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:point_sale/features/orders/providers/order_provider.dart';
import 'package:point_sale/features/orders/presentation/widgets/order_card.dart';
import 'package:point_sale/features/orders/presentation/widgets/order_details_modal.dart';
import 'package:point_sale/core/widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrderProvider>();

    return Scaffold(
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
          'Orders',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 20,
            color: Color(0xFF4A5565),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Container(
        color: const Color(0xFFF9FAFB),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search orders...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color(0xFF00B8D0)),
                  ),
                ),
                onChanged: provider.setSearchQuery,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildFilterChip(context, 'All', provider),
                  _buildFilterChip(context, 'Pending', provider),
                  _buildFilterChip(context, 'Completed', provider),
                  // _buildFilterChip(context, 'Cancelled', provider),
                ],
              ),
              const SizedBox(height: 20),
              // Summary Cards aligned horizontally
              Row(
                children: [
                  _buildSummaryCard(
                    context,
                    'Total',
                    provider.totalOrdersCount.toString(),
                    Colors.black87,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    context,
                    'Pending',
                    provider.pendingOrdersCount.toString(),
                    const Color(0xFFF97316),
                  ), // Orange
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    context,
                    'Completed',
                    provider.completedOrdersCount.toString(),
                    const Color(0xFF10B981),
                  ), // Green
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.error.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${provider.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: provider.fetchOrders,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : provider.orders.isEmpty
                    ? const Center(child: Text('No orders found'))
                    : RefreshIndicator(
                        onRefresh: provider.fetchOrders,
                        child: ListView.builder(
                          itemCount: provider.orders.length,
                          itemBuilder: (context, index) {
                            final order = provider.orders[index];
                            return OrderCard(
                              order: order,
                              onViewDetails: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) =>
                                      OrderDetailsModal(order: order),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String count,
    Color countColor,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: countColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    OrderProvider provider,
  ) {
    final isSelected = provider.selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        showCheckmark: false,
        label: Text(label),
        selected: isSelected,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF155DFC), // Blue
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8,
          ), // Look at picture: it is slightly rounded, not a full pill
          side: BorderSide(
            color: isSelected ? const Color(0xFF155DFC) : Colors.grey.shade300,
          ),
        ),
        onSelected: (selected) {
          if (selected) {
            provider.setSelectedFilter(label);
          }
        },
      ),
    );
  }
}
