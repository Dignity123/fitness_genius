import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class TagFilterRow extends StatelessWidget {
  final String title;
  final List<String> tags;
  final String selectedTag;
  final Function(String) onTagSelected;

  const TagFilterRow({
    Key? key,
    required this.title,
    required this.tags,
    required this.selectedTag,
    required this.onTagSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                letterSpacing: 2,
              ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tags.map((tag) {
              final isSelected = selectedTag == tag;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(tag.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    onTagSelected(selected ? tag : '');
                  },
                  backgroundColor: AppTheme.secondaryDark,
                  selectedColor: AppTheme.accentGreen,
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}