import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ParticipantsDropletTriad extends StatelessWidget {
  const ParticipantsDropletTriad({
    super.key,
    required this.urls, // 최대 3개
    this.big = 20,
    this.mid = 16,
    this.small = 12,
    this.spacing = 4, // 큰원-작은원 수직 간격
    this.midBottomGap = 2, // 중간원과 작은원 사이 틈
  });

  final List<String> urls;
  final double big, mid, small, spacing, midBottomGap;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    // 배치 박스 크기
    final width = mid + spacing + big;
    final height = big + spacing + small;

    // 좌표 계산 (위치 이동 로직 포함)
    final bigPos = Offset(width - big, -2); // 오른쪽 위 (위로 2px 이동)
    final smallPos = Offset(
      (width - small) / 2 + 4,
      height - small,
    ); // 아래 중앙 (오른쪽으로 4px 이동)
    final midTop =
        height - small - mid - midBottomGap + 3; // 작은원 위 (아래로 3px 이동)
    final midPos = Offset(0, midTop); // 왼쪽

    // url -> (big, mid, small) 순으로 사용
    final a = urls.isNotEmpty ? urls[0] : "";
    final b = urls.length > 1 ? urls[1] : a;
    final c = urls.length > 2 ? urls[2] : b;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: bigPos.dx, top: bigPos.dy, child: _circle(a, big)),
          Positioned(left: midPos.dx, top: midPos.dy, child: _circle(b, mid)),
          Positioned(
            left: smallPos.dx,
            top: smallPos.dy,
            child: _circle(c, small),
          ),
        ],
      ),
    );
  }

  Widget _circle(String url, double size) => ClipOval(
    child: CachedNetworkImage(
      imageUrl: url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: Colors.grey.shade200),
      errorWidget: (context, url, error) =>
          Container(color: Colors.grey.shade200),
    ),
  );
}
