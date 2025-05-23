import 'package:flutter/material.dart';
import 'package:ideal11/app_constant.dart';

class MatchDetailsBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  MatchDetailsBottomBar({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      height: 64, // compact height
      color: SUB_COLOR,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(icon: Icons.emoji_events, label: 'Contests', index: 0),
          SizedBox(width: 40),
          _buildTabItem(icon: Icons.groups, label: 'My Team', index: 2),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? MAIN_COLOR : INACTIVE_COLOR, size: 24),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? MAIN_COLOR : INACTIVE_COLOR,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
