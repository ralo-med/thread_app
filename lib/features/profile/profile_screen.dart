import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/profile_post_card.dart';

import '../../constants/sizes.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tabIndex = 0; // 0: Threads, 1: Replies

  final _miniFollower1 = 'https://i.pravatar.cc/40?img=12';
  final _miniFollower2 = 'https://i.pravatar.cc/40?img=16';

  // 더미 피드 데이터
  final List<Map<String, dynamic>> _posts = [
    {
      'username': 'jane_mobbin',
      'time': '5h',
      'text':
          'Give @john_mobbin a follow if you want to see more travel content!',
      'avatar': 'plant_icon',
      'hasCard': false,
      'isReply': false,
    },
    {
      'username': 'jane_mobbin',
      'time': '6h',
      'text': 'Tea. Spillage.',
      'avatar': 'plant_icon',
      'hasCard': true,
      'card': {
        'avatar': 'https://i.pravatar.cc/60?img=20',
        'name': 'iwetmyyplants',
        'verified': true,
        'snippet':
            'I\'m just going to say what we are all thinking and knowing is about to go downity down: There is about to be some piping hot tea spillage on here daily that people will be ...',
        'image': 'https://picsum.photos/seed/threads-card/1200/800',
      },
      'isReply': false,
    },
  ];

  // Replies 탭용 더미 데이터
  final List<Map<String, dynamic>> _replies = [
    // 1) 원글 (john_mobbin)
    {
      'threadId': 'A',
      'avatar': 'https://i.pravatar.cc/100?img=7',
      'username': 'john_mobbin',
      'time': '5h',
      'text': 'Always a dream to see the Medina in Morocco!',
      'hasCard': true,
      'card': {
        'avatar': 'earth_icon',
        'name': 'earthpix',
        'verified': true,
        'snippet':
            'What is one place you\'re absolutely traveling to by next year?',
        'replies': '256 replies',
      },
    },
    // 2) 내 댓글 (jane_mobbin)
    {
      'threadId': 'A',
      'avatar': 'plant_icon',
      'username': 'jane_mobbin',
      'time': '5h',
      'text': 'See you there!',
      'hasCard': false,
    },
    // 3) 또 다른 스레드의 원글
    {
      'threadId': 'B',
      'avatar': 'https://i.pravatar.cc/100?img=20',
      'username': 'iwetmyplants',
      'time': '6h',
      'text': 'Tea. Spillage.',
      'hasCard': false,
    },
    // 4) 위 3)의 댓글
    {
      'threadId': 'B',
      'avatar': 'plant_icon',
      'username': 'jane_mobbin',
      'time': '6h',
      'text': 'Count me in!',
      'hasCard': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _buildSliverAppBar(),
              SliverToBoxAdapter(child: _buildProfileHeader(context)),
              _buildSliverPersistentHeader(),
            ];
          },
          body: _buildTabBarView(),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.white,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleSpacing: 0,
      title: const SizedBox.shrink(),
      leading: const Icon(
        CupertinoIcons.globe,
        size: Sizes.size24,
        color: Colors.black,
      ),
      actions: [
        const FaIcon(FontAwesomeIcons.instagram, size: Sizes.size24),
        const SizedBox(width: Sizes.size16),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
          child: const Icon(CupertinoIcons.equal, size: Sizes.size24),
        ),
        const SizedBox(width: Sizes.size16),
      ],
    );
  }

  Widget _buildSliverPersistentHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabsHeaderDelegate(
        selectedIndex: _tabIndex,
        onTap: (i) => setState(() => _tabIndex = i),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(children: [_buildThreadsTab(), _buildRepliesTab()]);
  }

  Widget _buildThreadsTab() {
    final items = _posts.where((e) => e['isReply'] == false).toList();
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          Container(height: Sizes.size1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final p = items[index];
        return ProfilePostCard(
          avatar: p['avatar'] as String,
          username: p['username'] as String,
          timeAgo: p['time'] as String,
          text: p['text'] as String,
          card: p['hasCard'] == true ? p['card'] as Map<String, dynamic> : null,
          isReply: true, // Threads 탭에서는 세로선 숨김
        );
      },
    );
  }

  Widget _buildRepliesTab() {
    return ListView.separated(
      itemCount: _replies.length,
      separatorBuilder: (_, i) {
        // 같은 스레드 사이는 구분선 제거
        bool sameThreadAsNext =
            i < _replies.length - 1 &&
            _replies[i]['threadId'] == _replies[i + 1]['threadId'];
        return sameThreadAsNext
            ? const SizedBox.shrink()
            : Container(height: Sizes.size1, color: Colors.grey.shade200);
      },
      itemBuilder: (context, i) {
        final p = _replies[i];
        // 같은 스레드에서 첫 번째 포스트가 원글, 나머지는 답글
        bool isFirstInThread =
            i == 0 ||
            (i > 0 && _replies[i]['threadId'] != _replies[i - 1]['threadId']);
        return ProfilePostCard(
          avatar: p['avatar'] as String,
          username: p['username'] as String,
          timeAgo: p['time'] as String,
          text: p['text'] as String,
          card: p['hasCard'] == true ? p['card'] as Map<String, dynamic> : null,
          isReply: !isFirstInThread,
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        Sizes.size16,
        Sizes.size8,
        Sizes.size16,
        Sizes.size16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jane',
                      style: TextStyle(
                        fontSize: Sizes.size28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: Sizes.size6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'jane_mobbin',
                          style: TextStyle(
                            fontSize: Sizes.size14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: Sizes.size8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size8,
                            vertical: Sizes.size3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(Sizes.size12),
                          ),
                          child: const Text(
                            'threads.net',
                            style: TextStyle(
                              fontSize: Sizes.size12,
                              color: Colors.black38,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.size10),
                    const Text(
                      'Plant enthusiast!',
                      style: TextStyle(
                        fontSize: Sizes.size14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: Sizes.size10),

                    Row(
                      children: [
                        SizedBox(
                          height: Sizes.size20,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _tinyCircle(_miniFollower1),
                              Positioned(
                                left: Sizes.size14,
                                child: _tinyCircle(_miniFollower2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 26),
                        Text(
                          '2 followers',
                          style: TextStyle(
                            fontSize: Sizes.size14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: Sizes.size64,
                height: Sizes.size64,
                child: CircleAvatar(
                  radius: Sizes.size32,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(
                    Icons.local_florist,
                    color: Colors.green,
                    size: Sizes.size32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Sizes.size16),

          Row(
            children: [
              Expanded(child: _whitePillButton('Edit profile', onTap: () {})),
              const SizedBox(width: Sizes.size10),
              Expanded(child: _whitePillButton('Share profile', onTap: () {})),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tinyCircle(String url) {
    return Container(
      width: Sizes.size20,
      height: Sizes.size20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: Sizes.size2),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (c, _) => Container(color: Colors.grey.shade200),
          errorWidget: (c, u, e) => Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.person, size: Sizes.size12),
          ),
        ),
      ),
    );
  }

  Widget _whitePillButton(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size16,
          vertical: Sizes.size8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: Sizes.size1),
          borderRadius: BorderRadius.circular(Sizes.size10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: Sizes.size14,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  _TabsHeaderDelegate({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: maxExtent - Sizes.size2,
            child: Row(
              children: [
                _tabItem(context, 'Threads', 0),
                _tabItem(context, 'Replies', 1),
              ],
            ),
          ),
          Container(height: Sizes.size1, color: Colors.grey.shade200),
        ],
      ),
    );
  }

  Widget _tabItem(BuildContext context, String label, int index) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.black : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: Sizes.size8),
            Container(
              height: Sizes.size2,
              width: double.infinity,
              color: isSelected ? Colors.black : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => Sizes.size44;

  @override
  double get minExtent => Sizes.size44;

  @override
  bool shouldRebuild(_TabsHeaderDelegate oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}
