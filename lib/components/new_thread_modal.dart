import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewThreadModal extends StatefulWidget {
  const NewThreadModal({super.key});

  @override
  State<NewThreadModal> createState() => _NewThreadModalState();
}

class _NewThreadModalState extends State<NewThreadModal> {
  final TextEditingController _textController = TextEditingController();
  bool _isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTextEmpty = _textController.text.trim().isEmpty;
    });
  }

  void _onCancelPressed() => Navigator.of(context).pop();

  void _onPostPressed() {
    if (!_isTextEmpty) {
      // TODO: 실제 포스트 로직
      Navigator.of(context).pop();
    }
  }

  void _stopWriting() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double horizontalPadding = 16.0;

    // ---- 세로선/왼쪽 컬럼 관련 상수 ----
    const double avatarRadius = 24; // CircleAvatar(radius)
    const double avatarDia = avatarRadius * 2; // 48
    const double gapTop = 8; // 아바타 아래 간격
    const double gapBottom = 8; // 세로선과 꼬리 아이콘 사이 간격
    const double tailIcon = 20; // 꼬리 아이콘 지름
    const double minLine = 80; // ★ 세로선 최소 높이
    // 왼쪽 컬럼 최소 높이 = 아바타 + gapTop + 세로선(minLine) + gapBottom + 꼬리
    const double leftMinHeight =
        avatarDia + gapTop + minLine + gapBottom + tailIcon; // 164

    return Container(
      height: size.height * 0.90,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: _stopWriting,
          child: Column(
            children: [
              // 헤더
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: _onCancelPressed,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'New thread',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 60),
                  ],
                ),
              ),

              // 콘텐츠
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding + 8,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // 사용자 + 입력
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ---- 왼쪽: 아바타 + 세로선 + 꼬리 (최소 높이 보장) ----
                            SizedBox(
                              width: 80, // 48 + 12 여유
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minHeight: leftMinHeight, // ★ 여기로 최소 높이 고정
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade600,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: avatarRadius,
                                        backgroundColor: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.local_florist,
                                          color: Colors.green,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: gapTop),

                                    // 남는 높이만큼 채우되, 오른쪽 컨텐츠가 더 작아도
                                    // 위 ConstrainedBox 덕분에 최소 80은 확보됨.
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          width: 2,
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: gapBottom),
                                    Container(
                                      width: tailIcon,
                                      height: tailIcon,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.local_florist,
                                        color: Colors.grey.shade400,
                                        size: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ---- 오른쪽: 본문 ----
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'jane_mobbin',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    controller: _textController,
                                    maxLines: null, // 엔터 시 높이 증가
                                    maxLength: 500,
                                    autofocus: true,

                                    decoration: InputDecoration(
                                      hintText: 'Start a thread...',
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 16,
                                      ),
                                      border: InputBorder.none,
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                      isDense: true,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Transform.rotate(
                                    angle: 45 * 3.14159 / 180,
                                    child: Icon(
                                      Icons.attach_file,
                                      color: Colors.grey.shade500,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // 하단 설정/포스트
                      Row(
                        children: [
                          Text(
                            'Anyone can reply',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _isTextEmpty ? null : _onPostPressed,
                            child: Text(
                              'Post',
                              style: TextStyle(
                                color: _isTextEmpty
                                    ? Colors.blue.shade200
                                    : Colors.blue.shade600,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
