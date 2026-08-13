import 'package:flutter/material.dart';

class StatusFilters extends StatelessWidget {
  final List<String> statuses;
  final String selected;
  final Function(String) onSelect;

  const StatusFilters({
    super.key,
    required this.statuses,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = status == selected;
          return ChoiceChip(
            label: Text(status),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                onSelect(status);
              }
            },
            backgroundColor: isSelected ? const Color(0xFF00B8D0) : Colors.white,
            labelStyle: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 14,
              color: isSelected ? Colors.white : const Color(0xFF4A5565),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? const Color(0xFF00B8D0) : const Color(0xFFE5E7EB),
              ),
            ),
          );
        },
      ),
    );
  }
}
