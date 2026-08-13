import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:point_sale/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:point_sale/features/transactions/providers/transaction_provider.dart';
import 'package:point_sale/features/transactions/presentation/widgets/transaction_card.dart';
import 'package:point_sale/core/widgets/app_drawer.dart';


class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();

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
          'Transactions',
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
            icon: const Icon(
              Icons.file_download_outlined,
              color: Color(0xFF4A5565),
              size: 24,
            ),
            onPressed: () {
              // TODO: Implement export functionality
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
              onChanged: provider.setSearchQuery,
            ),
            SizedBox(height: 18),
            Row(
              spacing: 12,
              children: [
                _buildSummaryCard(
                  context,
                  'Total Sales',
                  '\$${provider.totalSales.toStringAsFixed(2)}',
                  const Color.fromRGBO(0, 212, 146, 1),
                ),
                _buildSummaryCard(
                  context,
                  'Total Items',
                  '${provider.totalItems}',
                  const Color.fromRGBO(74, 144, 226, 1),
                ),
                _buildSummaryCard(
                  context,
                  'Total Orders',
                  '${provider.transactionCount}',
                  const Color.fromRGBO(245, 166, 35, 1),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error.isNotEmpty
                      ? Center(child: Text(provider.error))
                      : provider.transactions.isEmpty
                          ? const Center(child: Text('No transactions found'))
                          : RefreshIndicator(
                              onRefresh: provider.fetchTransactions,
                              child: ListView.builder(
                                itemCount: provider.transactions.length,
                                itemBuilder: (context, index) {
                                  return TransactionCard(
                                    transaction: provider.transactions[index],
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String amount,
    Color color,
  ) {
    return Expanded(
      child: Card(
        color: color,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
