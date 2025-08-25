import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _isPrivateProfile = true;

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
              'Privacy',
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
          // Privacy 설정 항목들
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildPrivacyItem(
                  icon: CupertinoIcons.lock_shield,
                  label: 'Private profile',
                  trailing: CupertinoSwitch(
                    value: _isPrivateProfile,
                    onChanged: (value) {
                      setState(() {
                        _isPrivateProfile = value;
                      });
                    },
                    activeTrackColor: Colors.black,
                  ),
                ),
                _buildPrivacyItem(
                  icon: CupertinoIcons.at,
                  label: 'Mentions',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Everyone',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        CupertinoIcons.chevron_right,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                _buildPrivacyItem(
                  icon: CupertinoIcons.bell_slash,
                  label: 'Muted',
                  trailing: const Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
                _buildPrivacyItem(
                  icon: CupertinoIcons.eye_slash,
                  label: 'Hidden Words',
                  trailing: const Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
                _buildPrivacyItem(
                  icon: CupertinoIcons.person_2,
                  label: 'Profiles you follow',
                  trailing: const Icon(
                    CupertinoIcons.chevron_right,
                    size: 16,
                    color: Colors.grey,
                  ),
                ),
                const Divider(height: 1, thickness: 0.5),
                // Other privacy settings 섹션
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Other privacy settings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.arrow_up_right_square,
                            size: 22,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Some settings, like restrict, apply to both Threads and Instagram and can be managed on Instagram.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPrivacyItem(
                  icon: CupertinoIcons.person_crop_circle_badge_xmark,
                  label: 'Blocked profiles',
                  trailing: const Icon(
                    CupertinoIcons.arrow_up_right_square,
                    size: 22,
                    color: Colors.grey,
                  ),
                ),
                _buildPrivacyItem(
                  icon: CupertinoIcons.heart_slash,
                  label: 'Hide likes',
                  trailing: const Icon(
                    CupertinoIcons.arrow_up_right_square,
                    size: 22,
                    color: Colors.grey,
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

  Widget _buildPrivacyItem({
    required IconData icon,
    required String label,
    required Widget trailing,
  }) {
    return InkWell(
      onTap: () {},
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
              trailing,
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
