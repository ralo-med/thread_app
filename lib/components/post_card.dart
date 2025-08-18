import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/participants_droplet_triad.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.verified,
    required this.timeAgo,
    required this.text,
    required this.replies,
    required this.likes,
    this.participants = const [],
  });

  final String avatar;
  final String name;
  final bool verified;
  final String timeAgo;
  final String text;
  final int replies;
  final int likes;
  final List<String> participants;

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 40;
    const double gutterSpacing = 12;
    const double gutterWidth = avatarSize + gutterSpacing;

    final subtle = TextStyle(color: Colors.grey.shade600);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 왼쪽: 아바타 + 세로선
                SizedBox(
                  width: gutterWidth,
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: avatar,
                              width: avatarSize,
                              height: avatarSize,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: avatarSize,
                                height: avatarSize,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: avatarSize,
                                height: avatarSize,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          // 우측 하단에 검은 플러스 버튼
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 오른쪽 컨텐츠
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          if (verified) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ],
                          const Spacer(),
                          Text(timeAgo, style: subtle),
                          const SizedBox(width: 8),
                          const Icon(Icons.more_horiz, size: 20),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        text,
                        style: const TextStyle(fontSize: 16, height: 1.3),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: const [
                          _ActionIcon(FontAwesomeIcons.heart),
                          SizedBox(width: 18),
                          _ActionIcon(FontAwesomeIcons.comment),
                          SizedBox(width: 18),
                          _ActionIcon(FontAwesomeIcons.arrowsRotate),
                          SizedBox(width: 18),
                          _ActionIcon(FontAwesomeIcons.paperPlane),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 하단: 왼쪽 거터엔 물방울, 오른쪽엔 카운트 텍스트
          if (participants.isNotEmpty || replies > 0 || likes > 0)
            Row(
              children: [
                SizedBox(
                  width: gutterWidth,
                  child: Center(
                    child: ParticipantsDropletTriad(urls: participants),
                  ),
                ),
                if (replies > 0 || likes > 0)
                  Text('$replies replies · $likes likes', style: subtle),
              ],
            ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon(this.icon);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FaIcon(icon, size: 22);
  }
}
