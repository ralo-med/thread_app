import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'camera_library_sheet.dart';
import '../theme.dart';

class NewThreadModal extends StatefulWidget {
  const NewThreadModal({super.key});

  @override
  State<NewThreadModal> createState() => _NewThreadModalState();
}

class _NewThreadModalState extends State<NewThreadModal> {
  final TextEditingController _textController = TextEditingController();
  bool _isTextEmpty = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _openCameraSheet() async {
    final file = await showCameraLibrarySheet(context);
    if (!mounted) return;
    if (file != null) {
      setState(() => _selectedImage = file);
    }
  }

  Future<void> pickImageFromCamera() async {
    final cameraStatus = await Permission.camera.status;

    if (!cameraStatus.isGranted) {
      final permission = await Permission.camera.request();
      if (!permission.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('카메라 권한이 필요합니다')));
        }
        return;
      }
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('카메라 오류: $e')));
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('갤러리 오류: $e')));
      }
    }
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

    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;

    return Container(
      height: size.height * 0.90,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Scaffold(
        backgroundColor: colors.surface,
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
                child: SingleChildScrollView(
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
                                    GestureDetector(
                                      onTap: _openCameraSheet,
                                      child: Transform.rotate(
                                        angle: 45 * 3.14159 / 180,
                                        child: Icon(
                                          Icons.attach_file,
                                          color: Colors.grey.shade500,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                    if (_selectedImage != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        width: double.infinity,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: 1,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Stack(
                                            children: [
                                              Image.file(
                                                _selectedImage!,
                                                width: double.infinity,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                top: 8,
                                                right: 8,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedImage = null;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 100), // Spacer 대신 고정 간격
                      ],
                    ),
                  ),
                ),
              ),

              // 하단 설정/포스트 (Scaffold 밖으로 분리)
              Container(
                padding: const EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  bottom: 24,
                ),
                child: Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
