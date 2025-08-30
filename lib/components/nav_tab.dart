import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavTab extends StatelessWidget {
  const NavTab({
    super.key,
    required this.text,
    required this.isSelected,
    required this.icon,
    required this.selectedIcon,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            isSelected ? selectedIcon : icon,
            color: isSelected
                ? (theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black)
                : (theme.brightness == Brightness.dark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? (theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                  : (theme.brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
