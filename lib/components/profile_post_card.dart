import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePostCard extends StatelessWidget {
  const ProfilePostCard({
    super.key,
    required this.avatar,
    required this.username,
    required this.timeAgo,
    required this.text,
    this.card,
    this.isReply = false,
  });

  final String avatar;
  final String username;
  final String timeAgo;
  final String text;
  final Map<String, dynamic>? card;
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 36;
    const double gutterSpacing = 12;
    const double gutterWidth = avatarSize + gutterSpacing;

    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final subtle = TextStyle(
      color: theme.brightness == Brightness.dark
          ? Colors.grey.shade400
          : Colors.grey.shade600,
    );

    return Container(
      color: colors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왼쪽: 아바타 + 세로선
            SizedBox(
              width: gutterWidth,
              child: Column(
                children: [
                  // 아바타
                  avatar == 'plant_icon'
                      ? Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade600,
                              width: 0.5,
                            ),
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
                            border: Border.all(
                              color: Colors.grey.shade600,
                              width: 0.5,
                            ),
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
                  // 세로선 (답글이 아닐 때만 표시)
                  if (!isReply) ...[
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Transform.translate(
                          offset: const Offset(0, 12),
                          child: Container(
                            width: 2,
                            color: theme.brightness == Brightness.dark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        username,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
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
                  _buildRichText(text, theme),

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
      ),
    );
  }

  Widget _buildRichText(String text, ThemeData theme) {
    final List<TextSpan> spans = [];
    final RegExp mentionRegex = RegExp(r'@\w+');
    int lastIndex = 0;

    for (final Match match in mentionRegex.allMatches(text)) {
      // 멘션 이전 텍스트
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: TextStyle(
              fontSize: 15,
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
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
          style: TextStyle(
            fontSize: 15,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
        color: isDark ? const Color(0xFF0B0B0C) : Colors.white,
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
                Builder(
                  builder: (context) {
                    final th = Theme.of(context);
                    return Text(
                      card['name'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: th.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    );
                  },
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
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
              ),
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
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
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
                placeholder: (c, _) => Container(
                  height: 160,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
                errorWidget: (c, u, e) => Container(
                  height: 160,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
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
