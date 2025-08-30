import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'theme.dart';
import 'features/home/home_feed_screen.dart';
import 'features/search/search_screen.dart';
import 'features/activity/activity_screen.dart';
import 'features/profile/profile_screen.dart';
import 'components/new_thread_modal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thread App',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: Typography.blackMountainView,
        scaffoldBackgroundColor: AppColors.light.surface,
        brightness: Brightness.light,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        extensions: const <ThemeExtension<dynamic>>[AppColors.light],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        textTheme: Typography.whiteMountainView,
        scaffoldBackgroundColor: AppColors.dark.surface,
        brightness: Brightness.dark,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        extensions: const <ThemeExtension<dynamic>>[AppColors.dark],
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    if (index == 2) {
      // 가운데 버튼 (새 스레드 작성)
      _showNewThreadModal();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showNewThreadModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => const NewThreadModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const HomeFeedScreen(),
          ),
          Offstage(offstage: _selectedIndex != 1, child: const SearchScreen()),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const ActivityScreen(),
          ),
          Offstage(offstage: _selectedIndex != 4, child: const ProfileScreen()),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: colors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavIcon(
                icon: FontAwesomeIcons.house,
                selected: _selectedIndex == 0,
                onTap: () => _onTap(0),
              ),
              _NavIcon(
                icon: FontAwesomeIcons.magnifyingGlass,
                selected: _selectedIndex == 1,
                onTap: () => _onTap(1),
              ),
              _NavIcon(
                icon: FontAwesomeIcons.penToSquare,
                selected: false,
                onTap: () => _onTap(2),
              ),
              _NavIcon(
                icon: _selectedIndex == 3
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                selected: _selectedIndex == 3,
                onTap: () => _onTap(3),
              ),
              _NavIcon(
                icon: _selectedIndex == 4
                    ? FontAwesomeIcons.solidUser
                    : FontAwesomeIcons.user,
                selected: _selectedIndex == 4,
                onTap: () => _onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final inactiveColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade400
        : const Color(0xFFC7C7CC);
    return IconButton(
      onPressed: onTap,
      iconSize: _iconSize,
      color: selected ? activeColor : inactiveColor,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: FaIcon(icon),
    );
  }
}
