import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePostCard extends StatelessWidget {
  const ProfilePostCard({
    super.key,
    required this.avatar,
    required this.username,
    required this.timeAgo,
    required this.text,
    this.card,
  });

  final String avatar;
  final String username;
  final String timeAgo;
  final String text;
  final Map<String, dynamic>? card;

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 36;
    const double gutterSpacing = 12;

    final subtle = TextStyle(color: Colors.grey.shade600);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽: 아바타
          avatar == 'plant_icon'
              ? Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade600, width: 0.5),
                  ),
                  child: CircleAvatar(
                    radius: avatarSize / 2,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(
                      Icons.local_florist,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                )
              : avatar == 'earth_icon'
              ? Container(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade600, width: 0.5),
                  ),
                  child: CircleAvatar(
                    radius: avatarSize / 2,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(
                      Icons.public,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                )
              : ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: avatar,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: avatarSize,
                      height: avatarSize,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: avatarSize,
                      height: avatarSize,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                ),
          const SizedBox(width: gutterSpacing),

          // 오른쪽 컨텐츠
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Text(timeAgo, style: subtle),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.more_horiz, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                _buildRichText(text),

                // 카드(선택)
                if (card != null) ...[
                  const SizedBox(height: 8),
                  _LinkCard(card: card!),
                ],

                const SizedBox(height: 10),

                Row(
                  children: [
                    const _ActionIcon(FontAwesomeIcons.heart),
                    const SizedBox(width: 16),
                    const _ActionIcon(FontAwesomeIcons.comment),
                    const SizedBox(width: 16),
                    const _ActionIcon(FontAwesomeIcons.arrowsRotate),
                    const SizedBox(width: 16),
                    const _ActionIcon(FontAwesomeIcons.paperPlane),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(String text) {
    final List<TextSpan> spans = [];
    final RegExp mentionRegex = RegExp(r'@\w+');
    int lastIndex = 0;

    for (final Match match in mentionRegex.allMatches(text)) {
      // 멘션 이전 텍스트
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        );
      }

      // 멘션 텍스트 (트위터색)
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: const TextStyle(fontSize: 15, color: Colors.blue),
        ),
      );

      lastIndex = match.end;
    }

    // 마지막 부분 텍스트
    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({required this.card});

  final Map<String, dynamic> card;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 아바타 + 이름(+블루체크)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Row(
              children: [
                card['avatar'] == 'earth_icon'
                    ? Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 0.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(
                            Icons.public,
                            color: Colors.blue,
                            size: 12,
                          ),
                        ),
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: card['avatar'] as String,
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                          placeholder: (c, _) => Container(
                            width: 20,
                            height: 20,
                            color: Colors.grey.shade200,
                          ),
                          errorWidget: (c, u, e) => Container(
                            width: 20,
                            height: 20,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                const SizedBox(width: 8),
                Text(
                  card['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                if (card['verified'] == true) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.verified, color: Colors.blue, size: 16),
                ],
              ],
            ),
          ),

          // 스니펫
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              card['snippet'] as String,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 10),

          // replies 정보 (있는 경우만)
          if (card['replies'] != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                card['replies'] as String,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ] else ...[
            // 이미지 (replies가 없는 경우만)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: card['image'] as String,
                fit: BoxFit.cover,
                placeholder: (c, _) =>
                    Container(height: 160, color: Colors.grey.shade200),
                errorWidget: (c, u, e) =>
                    Container(height: 160, color: Colors.grey.shade200),
              ),
            ),
          ],
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
    return FaIcon(icon, size: 18);
  }
}
