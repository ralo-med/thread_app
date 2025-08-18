import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'features/home/home_feed_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thread App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const HomeFeedScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: Container(), // TODO: Add DiscoverScreen
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: Container(), // TODO: Add InboxScreen
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: Container(), // TODO: Add ProfileScreen
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
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

  static const _iconSize = 24.0;
  static const _inactive = Color(0xFFC7C7CC);
  static const _active = Colors.black;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      iconSize: _iconSize,
      color: selected ? _active : _inactive,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: FaIcon(icon),
    );
  }
}
