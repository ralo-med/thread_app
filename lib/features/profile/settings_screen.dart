import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'privacy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoggingOut = false;

  void _showLogoutDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('로그아웃'),
            content: const Text('정말로 로그아웃하시겠습니까?'),
            actions: [
              CupertinoDialogAction(
                child: const Text('취소'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('로그아웃'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _performLogout(context);
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('로그아웃'),
            content: const Text('정말로 로그아웃하시겠습니까?'),
            actions: [
              TextButton(
                child: const Text('취소'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('로그아웃'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _performLogout(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _performLogout(BuildContext context) async {
    setState(() {
      _isLoggingOut = true;
    });

    // 2초 대기
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoggingOut = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                selected: false,
                onTap: () => Navigator.of(context).pushReplacementNamed('/'),
              ),
              _NavIcon(
                icon: FontAwesomeIcons.magnifyingGlass,
                selected: false,
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed('/search'),
              ),
              _NavIcon(
                icon: FontAwesomeIcons.penToSquare,
                selected: false,
                onTap: () {},
              ),
              _NavIcon(
                icon: FontAwesomeIcons.heart,
                selected: false,
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed('/activity'),
              ),
              _NavIcon(
                icon: FontAwesomeIcons.solidUser,
                selected: true,
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            surfaceTintColor: Colors.white,
            centerTitle: true,
            leadingWidth: 100,
            leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).maybePop(),
              child: Row(
                children: const [
                  SizedBox(width: 8),
                  Icon(CupertinoIcons.back, size: 22, color: Colors.black),
                  SizedBox(width: 4),
                  Text(
                    'Back',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                ],
              ),
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: Colors.grey.shade200),
            ),
          ),
          // 설정 항목들
          SliverToBoxAdapter(
            child: Column(
              children: [
                const _SettingsRow(
                  icon: Icons.person_add,
                  label: 'Follow and invite friends',
                ),
                const _SettingsRow(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                ),
                _SettingsRow(
                  icon: Icons.lock_outline,
                  label: 'Privacy',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyScreen(),
                      ),
                    );
                  },
                ),
                const _SettingsRow(
                  icon: Icons.person_outline,
                  label: 'Account',
                ),
                const _SettingsRow(icon: Icons.help_outline, label: 'Help'),
                const _SettingsRow(icon: Icons.info_outline, label: 'About'),
              ],
            ),
          ),
          // 아래 여백 + Log out 영역
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(height: 1, color: Colors.grey.shade200),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: GestureDetector(
                    onTap: _isLoggingOut
                        ? null
                        : () => _showLogoutDialog(context),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.blue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        if (_isLoggingOut)
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CupertinoActivityIndicator(radius: 7),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              if (onTap != null)
                const Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                  color: Colors.grey,
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
