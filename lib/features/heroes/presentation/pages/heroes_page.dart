import 'package:fluent_ui/fluent_ui.dart';
import '../../../../core/theme/app_colors.dart';

class HeroesPage extends StatelessWidget {
  const HeroesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.shield,
              size: 48,
              color: AppColors.primary,
            ),
            SizedBox(height: 12),
            Text(
              'COREPUNK HEROES',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Em desenvolvimento (Fase de Heróis)...',
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
