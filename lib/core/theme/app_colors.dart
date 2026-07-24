import 'package:fluent_ui/fluent_ui.dart';

/// AppColors translates CSS design tokens into Flutter Color objects.
/// Source: Corepunk Help CSS Theme variables.
abstract class AppColors {
  // Core Background & Surfaces
  static const Color background = Color(0xFF0A0A0A);
  static const Color foreground = Color(0xFFD5B97D); // Corepunk Gold
  static const Color card = Color(0xFF171717);
  static const Color cardForeground = Color(0xFFFAFAFA);
  static const Color popover = Color(0xFF262626);
  static const Color popoverForeground = Color(0xFFFAFAFA);

  // Primary & Accent Colors
  static const Color primary = Color(0xFFD5B97D);
  static const Color primaryForeground = Color(0xFF000000);
  static const Color secondary = Color(0xFF000000);
  static const Color secondaryForeground = Color(0xFFD5B97D);
  static const Color accent = Color(0xFF000000);
  static const Color accentForeground = Color(0xFFD5B97D);

  // States & Utilitarios
  static const Color muted = Color(0xFF262626);
  static const Color mutedForeground = Color(0xFFA1A1A1);
  static const Color destructive = Color(0xFFFF6467);
  static const Color destructiveForeground = Color(0xFFFAFAFA);

  // Borders, Inputs & Focus Rings
  static const Color border = Color(0xFF282828);
  static const Color input = Color(0xFF343434);
  static const Color ring = Color(0xFF737373);

  // Corepunk Rarity Colors
  static const Color rarityCommon = Color(0xFF9D9D9D);
  static const Color rarityUncommon = Color(0xFF1EFF00);
  static const Color rarityRare = Color(0xFF0070DD);
  static const Color rarityEpic = Color(0xFFA335EE);
  static const Color rarityLegendary = Color(0xFFFF8000);
  static const Color rarityArtifact = Color(0xFFE6CC80);

  // Radii & Shadows
  static const double radius = 10.0; // 0.625rem = 10px
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(radius));

  static const BoxShadow shadowSm = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.10),
    blurRadius: 3,
    offset: Offset(0, 1),
  );

  static const BoxShadow shadowMd = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.25),
    blurRadius: 6,
    offset: Offset(0, 2),
  );
}
