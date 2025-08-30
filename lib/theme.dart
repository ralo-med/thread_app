import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color surface;

  const AppColors._({required this.surface});

  static const light = AppColors._(surface: Colors.white);
  static const dark = AppColors._(surface: Color(0xFF000000));

  @override
  AppColors copyWith({Color? surface}) {
    return AppColors._(surface: surface ?? this.surface);
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors._(surface: Color.lerp(surface, other.surface, t)!);
  }
}
