import 'package:flutter/material.dart';

abstract final class AppColors {
  static const navy = Color(0xFF101D32);
  static const blue = Color(0xFF246BFD);
  static const cyan = Color(0xFF28C2D1);
  static const canvas = Color(0xFFF4F6F9);
  static const border = Color(0xFFE3E8EF);
  static const muted = Color(0xFF667085);
  static const green = Color(0xFF13966F);
  static const amber = Color(0xFFE79A2D);
  static const red = Color(0xFFD94646);

  // Heritage-premium palette: entry flow (Welcome + sign-in) and accents
  // used to elevate the field-agent app. A formal, state-seal aesthetic —
  // deep emerald and bronze — rather than a dark tech/neon look.
  static const emerald = Color(0xFF0B3D2E);
  static const emeraldMid = Color(0xFF123B2C);
  static const emeraldDeep = Color(0xFF04140F);
  static const bronze = Color(0xFFC08A3E);
  static const bronzeLight = Color(0xFFE4C077);
  static const ivory = Color(0xFFF3ECDD);
  static const maroon = Color(0xFF7A2E2E);
  static const copper = Color(0xFFB5651D);
  static const slate = Color(0xFF3D4F5C);
  static const sage = Color(0xFF5F7D5F);
  static const indigo = Color(0xFF3B3169);
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          primary: AppColors.blue,
        ),
        scaffoldBackgroundColor: AppColors.canvas,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.canvas,
          foregroundColor: AppColors.navy,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: AppColors.navy,
            fontSize: 28,
            height: 1.1,
            fontWeight: FontWeight.w800,
            letterSpacing: -.7,
          ),
          titleLarge: TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
          ),
          titleMedium: TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(color: AppColors.muted, height: 1.45),
        ),
        cardTheme: CardThemeData(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: AppColors.bronze.withValues(alpha: .16),
          iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? AppColors.emerald
                  : AppColors.muted)),
          labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: states.contains(WidgetState.selected)
                  ? AppColors.emerald
                  : AppColors.muted)),
        ),
      );
}
