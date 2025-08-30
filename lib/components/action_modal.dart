import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'report_modal.dart';
import '../theme.dart';

class PostActionSheet extends StatelessWidget {
  const PostActionSheet({super.key});

  void _showReportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      isScrollControlled: true,
      builder: (context) => const ReportModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 22.0;
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final Color bgColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade900
        : Colors.grey.shade100;
    final Color dividerColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade300;

    Widget buildActionGroup(List<ActionSpec> items) {
      return Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              ActionItem(
                spec: items[i],
                isFirst: i == 0,
                isLast: i == items.length - 1,
                onReportTap: _showReportModal,
              ),
              if (i != items.length - 1)
                Divider(height: 1, thickness: 1, color: dividerColor),
            ],
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
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
            const SizedBox(height: 12),

            // 그룹 1
            buildActionGroup(const [
              ActionSpec(label: 'Unfollow', value: 'unfollow'),
              ActionSpec(label: 'Mute', value: 'mute'),
            ]),
            const SizedBox(height: 20),

            // 그룹 2
            buildActionGroup(const [
              ActionSpec(label: 'Hide', value: 'hide'),
              ActionSpec(label: 'Report', value: 'report', destructive: true),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class ActionSpec {
  const ActionSpec({
    required this.label,
    required this.value,
    this.destructive = false,
  });
  final String label;
  final String value;
  final bool destructive;
}

class ActionItem extends StatelessWidget {
  const ActionItem({
    super.key,
    required this.spec,
    required this.isFirst,
    required this.isLast,
    required this.onReportTap,
  });

  final ActionSpec spec;
  final bool isFirst;
  final bool isLast;
  final void Function(BuildContext context) onReportTap;

  @override
  Widget build(BuildContext context) {
    const double radius = 22.0;

    const double horizontalPadding = 16.0;
    const double fontSize = 15.0;

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? const Radius.circular(radius) : Radius.zero,
          topRight: isFirst ? const Radius.circular(radius) : Radius.zero,
          bottomLeft: isLast ? const Radius.circular(radius) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(radius) : Radius.zero,
        ),
      ),
      onTap: () {
        HapticFeedback.selectionClick();
        if (spec.value == 'report') {
          Navigator.pop(context); // 현재 액션 시트 닫기
          onReportTap(context);
        } else {
          Navigator.pop(context, spec.value);
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      title: Text(
        spec.label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: spec.destructive ? const Color(0xFFE53935) : Colors.black,
        ),
      ),
      minVerticalPadding: 16,
    );
  }
}
