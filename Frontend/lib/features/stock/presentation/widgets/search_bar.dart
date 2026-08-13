import 'package:flutter/material.dart';
import 'package:point_sale/core/theme/app_colors.dart';

class SearchBar extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const SearchBar({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search stock...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
      ),
    );
  }
}
