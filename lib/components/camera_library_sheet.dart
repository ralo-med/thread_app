import 'dart:io';
import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// 반환: 선택/촬영한 File (없으면 null)
Future<File?> showCameraLibrarySheet(BuildContext context) {
  return showModalBottomSheet<File?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.black, // 카메라 배경과 자연스럽게
    barrierColor: Colors.black54,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => const _CameraLibrarySheet(),
  );
}

class _CameraLibrarySheet extends StatefulWidget {
  const _CameraLibrarySheet();

  @override
  State<_CameraLibrarySheet> createState() => _CameraLibrarySheetState();
}

class _CameraLibrarySheetState extends State<_CameraLibrarySheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  CameraController? _cameraController;
  Future<void>? _initFuture;
  bool _hasCamPermission = false;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1,
    ); // 3개 탭, 중앙(인덱스 1)에서 시작
    _prepareCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _prepareCamera() async {
    try {
      print("카메라 준비 시작");

      // 권한 확인
      final cameraStatus = await Permission.camera.status;
      print("카메라 권한 상태: $cameraStatus");

      if (!cameraStatus.isGranted) {
        final camStatus = await Permission.camera.request();
        _hasCamPermission = camStatus.isGranted;
        print("카메라 권한 요청 결과: $camStatus");
      } else {
        _hasCamPermission = true;
      }

      if (!_hasCamPermission) {
        print("카메라 권한 없음");
        setState(() {});
        return;
      }

      // 사용 가능한 카메라 가져오기
      final cams = await availableCameras();
      print("사용 가능한 카메라 수: ${cams.length}");

      if (cams.isEmpty) {
        print("사용 가능한 카메라가 없음");
        setState(() {});
        return;
      }

      // 후면 카메라 우선, 없으면 첫 번째 카메라 사용
      final back = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );
      print("선택된 카메라: ${back.name}");

      final ctrl = CameraController(
        back,
        ResolutionPreset.ultraHigh,
        enableAudio: false,
      );

      setState(() {
        _cameraController = ctrl;
        _initFuture = ctrl.initialize();
      });

      // 플래시 모드 초기화
      await _initFuture;
      _flashMode = _cameraController!.value.flashMode;

      print("카메라 컨트롤러 초기화 완료");
    } catch (e) {
      print("카메라 준비 중 오류: $e");
      setState(() {});
    }
  }

  Future<void> _switchCamera() async {
    if (_cameraController == null) return;
    try {
      final cams = await availableCameras();
      if (cams.length < 2) return; // 카메라가 2개 미만이면 전환 불가

      final current = _cameraController!.description;
      final next = cams.firstWhere(
        (c) => c.lensDirection != current.lensDirection,
        orElse: () => current,
      );
      if (next == current) return;

      final newCtrl = CameraController(
        next,
        ResolutionPreset.ultraHigh,
        enableAudio: false,
      );
      await _cameraController!.dispose();
      _cameraController = newCtrl;
      _initFuture = newCtrl.initialize();
      setState(() {});
    } catch (e) {
      print("카메라 전환 오류: $e");
    }
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    if (_cameraController == null) return;
    try {
      await _cameraController!.setFlashMode(newFlashMode);
      _flashMode = newFlashMode;
      setState(() {});
    } catch (e) {
      print("플래시 모드 변경 오류: $e");
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null) return;
    try {
      await _initFuture;
      final file = await _cameraController!.takePicture();
      if (!mounted) return;
      Navigator.of(context).pop(File(file.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('촬영 실패: $e')));
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 80,
    );
    if (!mounted) return;
    if (x != null) Navigator.of(context).pop(File(x.path));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();

    return SizedBox(
      height: height, // 전체 화면
      child: Scaffold(
        backgroundColor: colors?.surface ?? Colors.black,
        body: Column(
          children: [
            // 카메라 or 라이브러리 컨텐츠 - 상단 여백 제거
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(), // 스와이프 금지
                children: [
                  const SizedBox.shrink(), // 왼쪽 가상 탭
                  _buildCameraTab(), // 중앙 카메라 탭
                  const SizedBox.shrink(), // 오른쪽 Library 탭 화면은 안 씀
                ],
              ),
            ),

            // 카메라 영역과 탭 사이에 살짝 간격(스크린샷처럼)
            const SizedBox(height: 6),

            // 하단 탭바
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // 왼쪽 1/3 (가상 탭)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {}, // 아무것도 안함
                        child: const SizedBox(height: 56),
                      ),
                    ),
                    // 중앙 1/3 (카메라 탭)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {}, // 이미 중앙에 있으므로 아무것도 안함
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(),
                          child: const Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 오른쪽 1/3 (Library 탭)
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await _pickFromGallery();
                          if (mounted) _tabController.animateTo(1);
                        },
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          child: const Text(
                            'Library',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraTab() {
    if (!_hasCamPermission) {
      return Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt, color: Colors.white70, size: 64),
                const SizedBox(height: 16),
                const Text(
                  '카메라 권한이 필요합니다.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  '사진을 촬영하기 위해 카메라 권한을 허용해주세요.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // 상단 뒤로가기 버튼
          Positioned(
            top: 50,
            left: 8,
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      );
    }

    if (_cameraController == null || _initFuture == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              '카메라 초기화 중...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return FutureBuilder(
      future: _initFuture,
      builder: (context, snap) {
        print("FutureBuilder 상태: ${snap.connectionState}, 에러: ${snap.error}");

        if (snap.connectionState != ConnectionState.done) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  '카메라 로딩 중...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (snap.hasError) {
          print("카메라 초기화 에러: ${snap.error}");
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  '카메라 오류: ${snap.error}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        print("카메라 컨트롤러 상태: ${_cameraController!.value.isInitialized}");
        print("카메라 미리보기 크기: ${_cameraController!.value.previewSize}");
        print("카메라 아스펙트 비율: ${_cameraController!.value.aspectRatio}");
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 카메라 미리보기 - 전체 화면 채우기, 하단 둥근 모서리
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: SizedBox.expand(child: CameraPreview(_cameraController!)),
            ),
            // 상단 뒤로가기 버튼
            Positioned(
              top: 50,
              left: 8,
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // 하단 컨트롤
            Positioned(
              bottom: 24,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  const Spacer(),
                  // 플래시 토글 버튼
                  IconButton(
                    icon: Icon(
                      _flashMode == FlashMode.off
                          ? Icons.flash_off
                          : _flashMode == FlashMode.auto
                          ? Icons.flash_auto
                          : Icons.flash_on,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      if (_flashMode == FlashMode.off) {
                        _setFlashMode(FlashMode.auto);
                      } else if (_flashMode == FlashMode.auto) {
                        _setFlashMode(FlashMode.always);
                      } else {
                        _setFlashMode(FlashMode.off);
                      }
                    },
                  ),
                  const SizedBox(width: 40),
                  // 셔터 버튼
                  GestureDetector(
                    onTap: _takePicture,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 바깥 흰색 링
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                        ),
                        // 가운데 흰색 원
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  // 카메라 전환 버튼
                  IconButton(
                    icon: const Icon(
                      Icons.cameraswitch,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: _switchCamera,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
