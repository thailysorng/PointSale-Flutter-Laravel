import 'package:flutter/material.dart';
import 'package:point_sale/core/services/api_service.dart';
import 'package:point_sale/core/widgets/app_drawer.dart';
import 'package:point_sale/features/home/data/models/dashboard_stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<DashboardStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _apiService.fetchDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawer(),
      body: FutureBuilder<DashboardStats>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stats = snapshot.data ?? DashboardStats.empty();

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _statsFuture = _apiService.fetchDashboardStats();
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section with Gradient
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF4A5565),
                          Color(0xFF00B8DB),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top bar with menu and title
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Builder(
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
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'PointSale',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 24,
                                  color: Colors.white,
                                  height: 1.33,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        
                        // Today's Sales Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Today's Sales",
                                    style: TextStyle(
                                      fontFamily: 'Arimo',
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                      height: 1.43,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.trending_up,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${stats.todaySales.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 30,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${stats.todayTransactions} transactions',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.75),
                                  height: 1.43,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  
                  // Content Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Actions Title
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 18,
                            color: Color(0xFF4A5565),
                            height: 1.56,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Quick Action Buttons
                        _buildActionButton(
                          icon: Icons.attach_money,
                          iconColor: Colors.lightBlue.shade300,
                          label: 'Quick Sale',
                          onTap: () {
                            Navigator.pushNamed(context, '/checkout');
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          icon: Icons.shopping_cart,
                          iconColor: Colors.blue.shade400,
                          label: 'View Orders',
                          onTap: () {
                            Navigator.pushNamed(context, '/orders');
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildActionButton(
                          icon: Icons.inventory_2,
                          iconColor: Colors.lightBlueAccent.shade700,
                          label: 'Manage Products',
                          onTap: () {
                            Navigator.pushNamed(context, '/stock');
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Stats Grid
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildStatCard(
                                label: 'Total Products',
                                value: stats.totalProducts.toString(),
                                valueColor: const Color(0xFF4A5565),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: _buildStatCard(
                                label: 'Low Stock Items',
                                value: stats.lowStockItems.toString(),
                                valueColor: stats.lowStockItems > 0 ? const Color(0xFFF54900) : const Color(0xFF4A5565),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildStatCard(
                                label: 'Pending Orders',
                                value: stats.pendingOrders.toString(),
                                valueColor: stats.pendingOrders > 0 ? const Color(0xFF155DFC) : const Color(0xFF4A5565),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: _buildStatCard(
                                label: 'This Week',
                                value: '\$${stats.thisWeekSales >= 1000 ? '${(stats.thisWeekSales / 1000).toStringAsFixed(1)}k' : stats.thisWeekSales.toStringAsFixed(0)}',
                                valueColor: const Color(0xFF00A63E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade700,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Arimo',
                fontSize: 18,
                color: Colors.white,
                height: 1.56,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.15,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Arimo',
              fontSize: 14,
              color: Color(0xFF4A5565),
              height: 1.43,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 24,
              color: valueColor,
              height: 1.33,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
