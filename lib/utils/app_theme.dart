import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════
//  TWENDE MARKITI — Design System
// ═══════════════════════════════════════════════════════

class TM {
  // ── Customer palette ─────────────────────────────────
  static const Color bg        = Color(0xFF0A0A0F);
  static const Color card      = Color(0xFF141420);
  static const Color card2     = Color(0xFF1A1A2E);
  static const Color primary   = Color(0xFFF5A623);
  static const Color primary2  = Color(0xFFFF6B35);
  static const Color accent    = Color(0xFF4ECDC4);
  static const Color green     = Color(0xFF00D4AA);
  static const Color red       = Color(0xFFFF4757);
  static const Color blue      = Color(0xFF4A9EFF);
  static const Color text      = Color(0xFFF0F0F8);
  static const Color text2     = Color(0xFF8888AA);
  static const Color text3     = Color(0xFF444466);
  static const Color border    = Color(0xFF1E1E30);

  // ── Admin palette ─────────────────────────────────────
  static const Color aBg      = Color(0xFF0A0F1A);
  static const Color aCard    = Color(0xFF111827);
  static const Color aCard2   = Color(0xFF1F2937);
  static const Color aBlue    = Color(0xFF3B82F6);
  static const Color aGreen   = Color(0xFF10B981);
  static const Color aYellow  = Color(0xFFF59E0B);
  static const Color aPurple  = Color(0xFF8B5CF6);
  static const Color aText    = Color(0xFFF3F4F6);
  static const Color aText2   = Color(0xFF9CA3AF);
  static const Color aBorder  = Color(0xFF1F2937);

  // ── Category colors ───────────────────────────────────
  static const Color catFruits = Color(0xFFFF6B6B);
  static const Color catVeg    = Color(0xFF4ECDC4);
  static const Color catMeat   = Color(0xFFFF8E53);
  static const Color catFish   = Color(0xFF45B7D1);
  static const Color catDairy  = Color(0xFFA8E6CF);
  static const Color catGrains = Color(0xFFFFD93D);
  static const Color catBev    = Color(0xFF6C5CE7);
  static const Color catSpices = Color(0xFFFF7675);

  // ── Gradients ─────────────────────────────────────────
  static const LinearGradient primaryGrad = LinearGradient(
    colors: [primary, primary2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient adminGrad = LinearGradient(
    colors: [aBlue, Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient greenGrad = LinearGradient(
    colors: [green, Color(0xFF00B894)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Radius ────────────────────────────────────────────
  static const double r4  = 4;
  static const double r8  = 8;
  static const double r12 = 12;
  static const double r16 = 16;
  static const double r20 = 20;
  static const double r24 = 24;
  static const double r32 = 32;

  // ── Spacing ───────────────────────────────────────────
  static const double p4  = 4;
  static const double p8  = 8;
  static const double p12 = 12;
  static const double p16 = 16;
  static const double p20 = 20;
  static const double p24 = 24;

  // ── Shadows ───────────────────────────────────────────
  static List<BoxShadow> primaryGlow = [
    BoxShadow(color: primary.withOpacity(.35), blurRadius: 24, offset: const Offset(0, 8)),
  ];
  static List<BoxShadow> adminGlow = [
    BoxShadow(color: aBlue.withOpacity(.35), blurRadius: 24, offset: const Offset(0, 8)),
  ];
  static List<BoxShadow> cardShadow = [
    BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 20, offset: const Offset(0, 8)),
  ];

  // ── Customer theme ────────────────────────────────────
  static ThemeData customerTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        background: bg,
        surface: card,
        primary: primary,
        secondary: primary2,
        tertiary: accent,
        error: red,
        onPrimary: Colors.black,
        onBackground: text,
        onSurface: text,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: text, fontSize: 32, fontWeight: FontWeight.w800),
          displayMedium: TextStyle(color: text, fontSize: 28, fontWeight: FontWeight.w800),
          displaySmall: TextStyle(color: text, fontSize: 24, fontWeight: FontWeight.w700),
          headlineLarge: TextStyle(color: text, fontSize: 22, fontWeight: FontWeight.w800),
          headlineMedium: TextStyle(color: text, fontSize: 20, fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(color: text, fontSize: 15, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(color: text, fontSize: 14, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: text, fontSize: 14, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(color: text2, fontSize: 13, fontWeight: FontWeight.w400),
          bodySmall: TextStyle(color: text2, fontSize: 12, fontWeight: FontWeight.w400),
          labelLarge: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.w700),
          labelSmall: TextStyle(color: text3, fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: text),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xEA0A0A0F),
        selectedItemColor: primary,
        unselectedItemColor: text3,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r16)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r14),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r14),
          borderSide: BorderSide(color: primary.withOpacity(.5), width: 1.5),
        ),
        hintStyle: const TextStyle(color: text3, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card2,
        selectedColor: primary.withOpacity(.15),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r20)),
        labelStyle: const TextStyle(color: text2, fontSize: 12, fontWeight: FontWeight.w600),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r16),
          side: const BorderSide(color: border),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: card2,
        contentTextStyle: const TextStyle(color: text, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Admin theme ───────────────────────────────────────
  static ThemeData adminTheme() {
    return customerTheme().copyWith(
      scaffoldBackgroundColor: aBg,
      colorScheme: const ColorScheme.dark(
        background: aBg,
        surface: aCard,
        primary: aBlue,
        secondary: aGreen,
        error: red,
        onPrimary: Colors.white,
        onBackground: aText,
        onSurface: aText,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xEA0A0F1A),
        selectedItemColor: aBlue,
        unselectedItemColor: Color(0xFF6B7280),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: aBlue,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r16)),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ── Border radius ─────────────────────────────────────
  static const double r14 = 14;

  // ── Helpers ───────────────────────────────────────────
  static BorderRadius br(double r) => BorderRadius.circular(r);
  static BorderRadius get brCard => BorderRadius.circular(r16);
  static BorderRadius get brInput => BorderRadius.circular(r14);

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':   return aYellow;
      case 'confirmed': return aGreen;
      case 'preparing': return aBlue;
      case 'shipping':  return aBlue;
      case 'delivered': return aGreen;
      case 'cancelled': return red;
      default:          return text2;
    }
  }

  static String formatPrice(double amount, {String currency = 'TZS'}) {
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$currency $formatted';
  }
}
