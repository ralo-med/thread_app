import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/participants_droplet_triad.dart';
import 'action_modal.dart';
import '../theme.dart';

class ImagePostCard extends StatefulWidget {
  const ImagePostCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.verified,
    required this.timeAgo,
    required this.text,
    required this.images,
    required this.replies,
    required this.likes,
    this.showMuteBadge = false,
    this.participants = const [],
  });

  final String avatar;
  final String name;
  final bool verified;
  final String timeAgo;
  final String text;
  final List<String> images;
  final int replies;
  final int likes;
  final bool showMuteBadge;
  final List<String> participants;

  @override
  State<ImagePostCard> createState() => _ImagePostCardState();
}

class _ImagePostCardState extends State<ImagePostCard> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final isScrolling = _scrollController.offset > 0;
    if (isScrolling != _isScrolling) {
      setState(() {
        _isScrolling = isScrolling;
      });
    }
  }

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      isScrollControlled: true,
      builder: (context) => const PostActionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 40;
    const double gutterSpacing = 12;
    const double gutterWidth = avatarSize + gutterSpacing;

    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final subtle = TextStyle(
      color: theme.brightness == Brightness.dark
          ? Colors.grey.shade400
          : Colors.grey.shade600,
    );
    final double screenWidth = MediaQuery.of(context).size.width;
    const double horizontalPadding = 14;
    final double contentWidth =
        screenWidth - (horizontalPadding * 2) - gutterWidth;
    final double imageHeight = contentWidth * 3 / 4;

    return Container(
      key: UniqueKey(),
      color: colors.surface,
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
                              imageUrl: widget.avatar,
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
                            color: theme.brightness == Brightness.dark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
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
                            widget.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          if (widget.verified) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ],
                          const Spacer(),
                          Text(widget.timeAgo, style: subtle),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _showActionSheet(context),
                            child: const Icon(Icons.more_horiz, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.text,
                        style: const TextStyle(fontSize: 16, height: 1.3),
                      ),
                      const SizedBox(height: 10),

                      // 이미지들
                      if (widget.images.isNotEmpty)
                        SizedBox(
                          height: imageHeight,
                          child: widget.images.length == 1
                              ? SizedBox(
                                  width: contentWidth,
                                  height: imageHeight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Stack(
                                      children: [
                                        SizedBox.expand(
                                          child: CachedNetworkImage(
                                            imageUrl: widget.images[0],
                                            fit: BoxFit.cover,
                                            memCacheWidth: 800,
                                            memCacheHeight: 600,
                                            placeholder: (context, url) =>
                                                Container(
                                                  color: Colors.grey.shade200,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: const Icon(
                                                        Icons.error,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                        if (widget.showMuteBadge)
                                          Positioned(
                                            right: 8,
                                            bottom: 8,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(
                                                  alpha: 0.6,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.volume_off,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  clipBehavior: Clip.none,
                                  child: Row(
                                    children: widget.images.asMap().entries.map((
                                      entry,
                                    ) {
                                      final index = entry.key;
                                      final imageUrl = entry.value;
                                      return Container(
                                        width: contentWidth,
                                        height: imageHeight,
                                        margin: EdgeInsets.only(
                                          right:
                                              index < widget.images.length - 1
                                              ? 8
                                              : 0,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          child: Stack(
                                            children: [
                                              SizedBox.expand(
                                                child: CachedNetworkImage(
                                                  imageUrl: imageUrl,
                                                  fit: BoxFit.cover,
                                                  memCacheWidth: 800,
                                                  memCacheHeight: 600,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                        color: Colors
                                                            .grey
                                                            .shade200,
                                                        child: const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                            color: Colors
                                                                .grey
                                                                .shade200,
                                                            child: const Icon(
                                                              Icons.error,
                                                            ),
                                                          ),
                                                ),
                                              ),
                                              if (widget.showMuteBadge)
                                                Positioned(
                                                  right: 8,
                                                  bottom: 8,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.6,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            18,
                                                          ),
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(
                                                        6,
                                                      ),
                                                      child: Icon(
                                                        Icons.volume_off,
                                                        size: 18,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
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
          if (widget.participants.isNotEmpty ||
              widget.replies > 0 ||
              widget.likes > 0)
            Row(
              children: [
                SizedBox(
                  width: gutterWidth,
                  child: Center(
                    child: ParticipantsDropletTriad(urls: widget.participants),
                  ),
                ),
                if (widget.replies > 0 || widget.likes > 0)
                  Text(
                    '${widget.replies} replies · ${widget.likes} likes',
                    style: subtle,
                  ),
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
