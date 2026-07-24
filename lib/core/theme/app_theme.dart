import 'package:fluent_ui/fluent_ui.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static FluentThemeData get darkTheme {
    return FluentThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      navigationPaneTheme: NavigationPaneThemeData(
        backgroundColor: AppColors.background,
      ),
      activeColor: AppColors.primary,
      accentColor: AccentColor.swatch({
        'darkest': AppColors.primary.withValues(alpha: 0.8),
        'darker': AppColors.primary.withValues(alpha: 0.9),
        'dark': AppColors.primary,
        'normal': AppColors.primary,
        'light': AppColors.primary.withValues(alpha: 0.9),
        'lighter': AppColors.primary.withValues(alpha: 0.8),
        'lightest': AppColors.primary.withValues(alpha: 0.7),
      }),
      inactiveBackgroundColor: AppColors.muted,
      cardColor: AppColors.card,
      shadowColor: const Color(0xFF000000),
      typography: Typography.fromBrightness(
        brightness: Brightness.dark,
      ).apply(
        displayColor: AppColors.foreground,
      ),
      dialogTheme: const ContentDialogThemeData(
        decoration: BoxDecoration(
          color: AppColors.popover,
          borderRadius: AppColors.borderRadius,
        ),
      ),
    );
  }
}
