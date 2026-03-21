import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onChanged;

  const SearchBarWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search exercises...',
          prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
          filled: true,
          fillColor: AppTheme.secondaryDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.accentGreen, width: 2),
          ),
        ),
      ),
    );
  }
}