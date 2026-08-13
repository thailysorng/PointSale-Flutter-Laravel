import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:point_sale/core/widgets/app_drawer.dart';
import 'package:point_sale/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:point_sale/features/analytics/providers/analytics_provider.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsProvider>().fetchAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyticsProvider>();
    final data = provider.data;

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
          'Analytics',
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
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error.isNotEmpty
              ? Center(child: Text(provider.error))
              : data == null
                  ? const Center(child: Text('No data available'))
                  : RefreshIndicator(
                      onRefresh: provider.fetchAnalytics,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTimeFilter(provider),
                            const SizedBox(height: 16),
                            _buildSummaryCards(data['summary']),
                            const SizedBox(height: 16),
                            _buildSalesOverviewCard(data['sales_trends']),
                            const SizedBox(height: 16),
                            _buildOrdersTrendCard(data['sales_trends']),
                            const SizedBox(height: 16),
                            _buildSalesByCategoryCard(data['category_sales']),
                            const SizedBox(height: 16),
                            _buildTopSellingProductsCard(data['top_products']),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildTimeFilter(AnalyticsProvider provider) {
    return Row(
      children: [
        _buildFilterChip('Week', provider),
        const SizedBox(width: 8),
        _buildFilterChip('Month', provider),
        const SizedBox(width: 8),
        _buildFilterChip('Year', provider),
      ],
    );
  }

  Widget _buildFilterChip(String label, AnalyticsProvider provider) {
    final isSelected = provider.period == label.toLowerCase();
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ChoiceChip(
          label: Center(child: Text(label)),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              provider.setPeriod(label);
            }
          },
          padding: EdgeInsets.zero,
          showCheckmark: false,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.borderDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> summary) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          icon: Icons.attach_money_rounded,
          iconColor: Colors.greenAccent.shade700,
          title: 'Total Revenue',
          value: '\$${_formatValue(summary['total_revenue'])}',
          change: summary['revenue_change'] ?? '',
          changeColor: Colors.green,
        ),
        _buildSummaryCard(
          icon: Icons.show_chart,
          iconColor: Colors.blueGrey.shade700,
          title: 'Avg Order Value',
          value: '\$${_formatValue(summary['avg_order_value'])}',
          change: '',
          changeColor: Colors.green,
        ),
        _buildSummaryCard(
          icon: Icons.shopping_bag_outlined,
          iconColor: Colors.orangeAccent.shade700,
          title: 'Total Items',
          value: '${summary['total_items']}',
          change: '',
          changeColor: Colors.green,
        ),
        _buildSummaryCard(
          icon: Icons.shopping_cart_outlined,
          iconColor: Colors.blueAccent.shade700,
          title: 'Total Orders',
          value: '${summary['order_count']}',
          change: summary['order_change'] ?? '',
          changeColor: Colors.green,
        ),
      ],
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return '0.00';
    final numValue = value is num ? value : double.tryParse(value.toString()) ?? 0.0;
    return NumberFormat('#,##0.00').format(numValue);
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String change,
    required Color changeColor,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.borderDark),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: iconColor,
              ),
              child: Icon(icon, color: Colors.white),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (change.isNotEmpty)
                  Text(
                    change,
                    style: TextStyle(color: changeColor, fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesOverviewCard(List<dynamic> trends) {
    if (trends.isEmpty) return const SizedBox.shrink();

    final List<FlSpot> spots = [];
    double maxY = 0;
    for (int i = 0; i < trends.length; i++) {
      final revenue = double.tryParse(trends[i]['revenue'].toString()) ?? 0.0;
      spots.add(FlSpot(i.toDouble(), revenue));
      if (revenue > maxY) maxY = revenue;
    }

    maxY = (maxY * 1.2).ceilToDouble();
    if (maxY == 0) maxY = 1000;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.borderDark),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= trends.length) return const SizedBox.shrink();
                          final dateStr = trends[index]['date'].toString();
                          final date = DateTime.tryParse(dateStr);
                          final text = date != null ? DateFormat('MM/dd').format(date) : dateStr;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(_formatCompact(value), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (trends.length - 1).toDouble(),
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCompact(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value.toStringAsFixed(0);
  }

  Widget _buildOrdersTrendCard(List<dynamic> trends) {
    if (trends.isEmpty) return const SizedBox.shrink();

    final List<BarChartGroupData> groups = [];
    double maxY = 0;
    for (int i = 0; i < trends.length; i++) {
      final count = double.tryParse(trends[i]['order_count'].toString()) ?? 0.0;
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count,
              color: const Color.fromRGBO(16, 185, 129, 1),
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
      if (count > maxY) maxY = count;
    }

    maxY = (maxY * 1.2).ceilToDouble();
    if (maxY == 0) maxY = 10;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.borderDark),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Orders Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= trends.length) return const SizedBox.shrink();
                          final dateStr = trends[index]['date'].toString();
                          final date = DateTime.tryParse(dateStr);
                          final text = date != null ? DateFormat('MM/dd').format(date) : dateStr;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: groups,
                  minY: 0,
                  maxY: maxY,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesByCategoryCard(List<dynamic> categorySales) {
    if (categorySales.isEmpty) return const SizedBox.shrink();

    final totalRevenue = categorySales.fold(0.0, (sum, item) => sum + (double.tryParse(item['revenue'].toString()) ?? 0.0));

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.borderDark),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ...categorySales.map((item) {
              final revenue = double.tryParse(item['revenue'].toString()) ?? 0.0;
              final percent = totalRevenue > 0 ? (revenue / totalRevenue) * 100 : 0.0;
              return _buildCategoryProgress(item['name'], percent.toInt(), 100);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryProgress(String category, int value, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(fontSize: 16)),
              Text('$value%', style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value / total,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellingProductsCard(List<dynamic> topProducts) {
    if (topProducts.isEmpty) return const SizedBox.shrink();

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.borderDark),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Selling Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topProducts.length,
              separatorBuilder: (context, index) => const Divider(height: 1, thickness: 0.5),
              itemBuilder: (context, index) {
                final product = topProducts[index];
                return _buildProductListItem(
                  index + 1,
                  product['name'],
                  '${product['sold_count']} sold',
                  '\$${_formatValue(product['revenue'])}',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListItem(
    int rank,
    String name,
    String soldQuantity,
    String revenue,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  soldQuantity,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            revenue,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
