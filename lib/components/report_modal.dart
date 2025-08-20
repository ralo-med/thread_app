import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReportModal extends StatelessWidget {
  const ReportModal({super.key});

  @override
  Widget build(BuildContext context) {
    const double radius = 22.0;
    const double horizontalPadding = 16.0;

    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          // 드래그 핸들
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 제목
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              'Report',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),

          // 구분선
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
          const SizedBox(height: 12),

          // 질문
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Why are you reporting this thread?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 안내 문구
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              'Your report is anonymous, except if you\'re reporting an intellectual property infringement. If someone is in immediate danger, call the local emergency services - don\'t wait.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 구분선
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
          const SizedBox(height: 8),

          // 스크롤 가능한 신고 옵션들
          Flexible(
            child: SingleChildScrollView(
              child: Column(children: _buildReportOptions(context)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<Widget> _buildReportOptions(BuildContext context) {
    const double horizontalPadding = 16.0;

    final options = [
      'I just don\'t like it',
      'It\'s unlawful content under NetzDG',
      'It\'s spam',
      'Hate speech or symbols',
      'Nudity or sexual activity',
      'False information',
      'Violence or dangerous organizations',
      'Intellectual property violation',
      'Suicide or self-injury',
      'Eating disorders',
      'Scam or fraud',
      'Misinformation',
    ];

    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      final isLast = index == options.length - 1;

      return Column(
        children: [
          ListTile(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context, option);
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            title: Text(
              option,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
            minVerticalPadding: 16,
          ),
          if (!isLast)
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
        ],
      );
    }).toList();
  }
}
