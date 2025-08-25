import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/profile_post_card.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
              size: 24,
              color: Colors.black,
            ),
            actions: [
              const FaIcon(FontAwesomeIcons.instagram, size: 24),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                child: const Icon(CupertinoIcons.equal, size: 24),
              ),
              const SizedBox(width: 16),
            ],
          ),

          SliverToBoxAdapter(child: _buildProfileHeader(context)),

          SliverPersistentHeader(
            pinned: true,
            delegate: _TabsHeaderDelegate(
              selectedIndex: _tabIndex,
              onTap: (i) => setState(() => _tabIndex = i),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 6)),

          _buildFeedSliver(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'jane_mobbin',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'threads.net',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black38,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Plant enthusiast!',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              _tinyCircle(_miniFollower1),
                              Positioned(
                                left: 14,
                                child: _tinyCircle(_miniFollower2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 26),
                        Text(
                          '2 followers',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: 64,
                height: 64,
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(
                    Icons.local_florist,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(child: _whitePillButton('Edit profile', onTap: () {})),
              const SizedBox(width: 10),
              Expanded(child: _whitePillButton('Share profile', onTap: () {})),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tinyCircle(String url) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (c, _) => Container(color: Colors.grey.shade200),
          errorWidget: (c, u, e) => Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.person, size: 12),
          ),
        ),
      ),
    );
  }

  Widget _whitePillButton(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  SliverList _buildFeedSliver() {
    if (_tabIndex == 0) {
      final items = _posts.where((e) => e['isReply'] == false).toList();
      return SliverList.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            Container(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final p = items[index];
          return ProfilePostCard(
            avatar: p['avatar'] as String,
            username: p['username'] as String,
            timeAgo: p['time'] as String,
            text: p['text'] as String,
            card: p['hasCard'] == true
                ? p['card'] as Map<String, dynamic>
                : null,
            isReply: true, // Threads 탭에서는 세로선 숨김
          );
        },
      );
    } else {
      return SliverList.separated(
        itemCount: _replies.length,
        separatorBuilder: (_, i) {
          // 같은 스레드 사이는 구분선 제거
          bool sameThreadAsNext =
              i < _replies.length - 1 &&
              _replies[i]['threadId'] == _replies[i + 1]['threadId'];
          return sameThreadAsNext
              ? const SizedBox.shrink()
              : Container(height: 1, color: Colors.grey.shade200);
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
            card: p['hasCard'] == true
                ? p['card'] as Map<String, dynamic>
                : null,
            isReply: !isFirstInThread,
          );
        },
      );
    }
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
            height: maxExtent - 2,
            child: Row(
              children: [
                _tabItem(context, 'Threads', 0),
                _tabItem(context, 'Replies', 1),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey.shade200),
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
            const SizedBox(height: 8),
            Container(
              height: 2,
              width: double.infinity,
              color: isSelected ? Colors.black : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 44;

  @override
  double get minExtent => 44;

  @override
  bool shouldRebuild(_TabsHeaderDelegate oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}
