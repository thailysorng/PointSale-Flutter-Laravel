class DashboardStats {
  final double todaySales;
  final int todayTransactions;
  final int totalProducts;
  final int lowStockItems;
  final int pendingOrders;
  final double thisWeekSales;

  DashboardStats({
    required this.todaySales,
    required this.todayTransactions,
    required this.totalProducts,
    required this.lowStockItems,
    required this.pendingOrders,
    required this.thisWeekSales,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      todaySales: (json['today_sales'] as num).toDouble(),
      todayTransactions: json['today_transactions'] as int,
      totalProducts: json['total_products'] as int,
      lowStockItems: json['low_stock_items'] as int,
      pendingOrders: json['pending_orders'] as int,
      thisWeekSales: (json['this_week_sales'] as num).toDouble(),
    );
  }

  factory DashboardStats.empty() {
    return DashboardStats(
      todaySales: 0.0,
      todayTransactions: 0,
      totalProducts: 0,
      lowStockItems: 0,
      pendingOrders: 0,
      thisWeekSales: 0.0,
    );
  }
}
