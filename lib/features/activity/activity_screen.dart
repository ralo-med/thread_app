import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['All', 'Replies', 'Mentions', 'Likes', 'Follows'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 앱바
          SliverAppBar(
            pinned: true,
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            surfaceTintColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: const Text(
              'Activity',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _tabs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tab = entry.value;
                      final isSelected = index == _selectedTabIndex;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: 110,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.white,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            tab,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          // 탭 아래 여백
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          // 활동 목록
          SliverList.list(children: _buildActivityItems()),
        ],
      ),
    );
  }

  List<Widget> _buildActivityItems() {
    final activities = [
      {
        'username': 'john_mobbin',
        'timeAgo': '4h',
        'activityType': 'Mentioned you',
        'content':
            'Here\'s a thread you should follow if you love botany @jane_mobbin',
        'profileImage': 'https://i.pravatar.cc/100?img=1',
        'overlayIcon': Icons.alternate_email,
        'overlayColor': Colors.green,
        'hasButton': false,
        'category': 'mentions',
      },
      {
        'username': 'john_mobbin',
        'timeAgo': '4h',
        'activityType': '',
        'originalContent':
            'Starting out my gardening club with three amazing plants that I just got from the local nursery. These are going to be perfect for my new project and I can\'t wait to see them grow!',
        'replyContent': 'Count me in!',
        'profileImage': 'https://i.pravatar.cc/100?img=1',
        'overlayIcon': Icons.reply,
        'overlayColor': Colors.blue,
        'hasButton': false,
        'category': 'replies',
      },
      {
        'username': 'the.plantdads',
        'timeAgo': '5h',
        'activityType': 'Followed you',
        'content': '',
        'profileImage': 'https://i.pravatar.cc/100?img=2',
        'overlayIcon': Icons.person_add,
        'overlayColor': Colors.purple,
        'hasButton': true,
        'buttonText': 'Following',
        'category': 'follows',
      },
      {
        'username': 'the.plantdads',
        'timeAgo': '5h',
        'activityType': '',
        'content': 'Definitely broken! 🧵👀🌱',
        'profileImage': 'https://i.pravatar.cc/100?img=2',
        'overlayIcon': Icons.favorite,
        'overlayColor': Colors.pink,
        'hasButton': false,
        'category': 'likes',
      },
      {
        'username': 'theberryjungle',
        'timeAgo': '5h',
        'activityType': '',
        'content': '🌱👀🧵',
        'profileImage': 'https://i.pravatar.cc/100?img=3',
        'overlayIcon': Icons.favorite,
        'overlayColor': Colors.pink,
        'hasButton': false,
        'category': 'likes',
      },
    ];

    // 탭에 따른 필터링
    List<Map<String, dynamic>> filteredActivities = [];

    switch (_selectedTabIndex) {
      case 0: // All
        filteredActivities = activities;
        break;
      case 1: // Replies
        filteredActivities = activities
            .where((activity) => activity['category'] == 'replies')
            .toList();
        break;
      case 2: // Mentions
        filteredActivities = activities
            .where((activity) => activity['category'] == 'mentions')
            .toList();
        break;
      case 3: // Likes
        filteredActivities = activities
            .where((activity) => activity['category'] == 'likes')
            .toList();
        break;
      case 4: // Follows
        filteredActivities = activities
            .where((activity) => activity['category'] == 'follows')
            .toList();
        break;
    }

    List<Widget> widgets = [];

    for (int i = 0; i < filteredActivities.length; i++) {
      final activity = filteredActivities[i];

      widgets.add(
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 이미지 (오버레이 아이콘 포함)
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: activity['profileImage'] as String,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  // 오버레이 아이콘
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: activity['overlayColor'] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        activity['overlayIcon'] as IconData,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // 활동 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          activity['username'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        if (activity['isVerified'] == true) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ],
                        const SizedBox(width: 8),
                        Text(
                          activity['timeAgo'] as String,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    if ((activity['activityType'] as String).isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        activity['activityType'] as String,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    if (activity['originalContent'] != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        activity['originalContent'] as String,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                    if (activity['replyContent'] != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        activity['replyContent'] as String,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    if (activity['content'] != null &&
                        activity['originalContent'] == null &&
                        (activity['content'] as String).isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        activity['content'] as String,
                        style: TextStyle(
                          color: activity['category'] == 'likes'
                              ? Colors.grey.shade600
                              : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // 버튼 (있는 경우만)
              if (activity['hasButton'] == true) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    activity['buttonText'] as String,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );

      // 구분선 추가 (마지막 항목 제외)
      if (i < filteredActivities.length - 1) {
        widgets.add(Container(height: 1, color: Colors.grey.shade200));
      }
    }

    return widgets;
  }
}
