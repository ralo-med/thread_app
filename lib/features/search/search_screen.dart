import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              'Search',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                child: CupertinoSearchTextField(
                  controller: _searchController,
                  placeholder: 'Search',
                  style: const TextStyle(fontSize: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          // 검색 결과 목록
          SliverList.list(children: _buildSearchResults()),
        ],
      ),
    );
  }

  List<Widget> _buildSearchResults() {
    final accounts = [
      {
        'username': 'rjmithun',
        'fullName': 'Mithun',
        'followers': '26.6K followers',
        'isVerified': true,
        'profileImage': 'https://i.pravatar.cc/100?img=1',
        'hasSmallProfile': false,
      },
      {
        'username': 'vicenews',
        'fullName': 'VICE News',
        'followers': '301K followers',
        'isVerified': true,
        'profileImage': 'https://i.pravatar.cc/100?img=2',
        'hasSmallProfile': true,
        'smallProfileImage': 'https://i.pravatar.cc/100?img=2',
      },
      {
        'username': 'trevornoah',
        'fullName': 'Trevor Noah',
        'followers': '789K followers',
        'isVerified': true,
        'profileImage': 'https://i.pravatar.cc/100?img=3',
        'hasSmallProfile': false,
      },
      {
        'username': 'condenasttraveller',
        'fullName': 'Condé Nast Traveller',
        'followers': '130K followers',
        'isVerified': true,
        'profileImage': 'https://i.pravatar.cc/100?img=4',
        'hasSmallProfile': false,
      },
      {
        'username': 'chef_pillai',
        'fullName': 'Suresh Pillai',
        'followers': '69.2K followers',
        'isVerified': true,
        'profileImage': 'https://i.pravatar.cc/100?img=5',
        'hasSmallProfile': false,
      },
      {
        'username': 'malala',
        'fullName': 'Malala Yousafzai',
        'followers': '237K followers',
        'isVerified': true,
        'profileImage': 'https://i.pravatar.cc/100?img=6',
        'hasSmallProfile': true,
        'smallProfileImage': 'https://i.pravatar.cc/100?img=2',
      },
      {
        'username': 'sebin_cyriac',
        'fullName': 'Fishing_freaks',
        'followers': '53.2K followers',
        'isVerified': true,
        'profileImage': 'https://i.pravatar.cc/100?img=7',
        'hasSmallProfile': false,
      },
    ];

    List<Widget> widgets = [];

    for (int i = 0; i < accounts.length; i++) {
      final account = accounts[i];

      widgets.add(
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프로필 이미지
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: account['profileImage'] as String,
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
              const SizedBox(width: 12),
              // 사용자 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          account['username'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        if (account['isVerified'] == true) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      account['fullName'] as String,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (account['hasSmallProfile'] == true) ...[
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: account['smallProfileImage'] as String,
                              width: 16,
                              height: 16,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 16,
                                height: 16,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 12,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 16,
                                height: 16,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          account['followers'] as String,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 팔로우 버튼
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Follow',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // 구분선 추가 (마지막 항목 제외)
      if (i < accounts.length - 1) {
        widgets.add(Container(height: 1, color: Colors.grey.shade200));
      }
    }

    return widgets;
  }
}
