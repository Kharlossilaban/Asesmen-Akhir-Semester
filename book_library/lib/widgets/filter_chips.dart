import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';
import '../utils/constants.dart';
import '../utils/theme.dart';

/// Filter Chips Widget - displays filter options for book status
class FilterChipsWidget extends StatelessWidget {
  const FilterChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip(
                  context,
                  'all',
                  AppConstants.statusLabels['all']!,
                  filterProvider,
                ),
                const SizedBox(width: 8),
                _buildChip(
                  context,
                  'unread',
                  AppConstants.statusLabels['unread']!,
                  filterProvider,
                ),
                const SizedBox(width: 8),
                _buildChip(
                  context,
                  'reading',
                  AppConstants.statusLabels['reading']!,
                  filterProvider,
                ),
                const SizedBox(width: 8),
                _buildChip(
                  context,
                  'finished',
                  AppConstants.statusLabels['finished']!,
                  filterProvider,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(
    BuildContext context,
    String status,
    String label,
    FilterProvider filterProvider,
  ) {
    final isSelected = filterProvider.selectedStatus == status;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        filterProvider.setStatus(status);
      },
      selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
