import 'package:flutter/material.dart';

class LowStockAlert extends StatefulWidget {
  final int lowStockCount;
  final Future<void> Function() onRestockAll;

  const LowStockAlert({
    super.key,
    required this.lowStockCount,
    required this.onRestockAll,
  });

  @override
  State<LowStockAlert> createState() => _LowStockAlertState();
}

class _LowStockAlertState extends State<LowStockAlert> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.lowStockCount == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      color: const Color(0xFFFEE2E2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFFCA5A5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Low Stock Alert',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF991B1B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.lowStockCount} items need restocking',
                    style: const TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 14,
                      color: Color(0xFFB91C1C),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : () async {
                setState(() => _isLoading = true);
                try {
                  await widget.onRestockAll();
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error restocking all: $e')),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Restock All',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
