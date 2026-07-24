import 'package:fluent_ui/fluent_ui.dart';
import '../../../../core/theme/app_colors.dart';

class GuidesPage extends StatelessWidget {
  const GuidesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.library,
              size: 48,
              color: AppColors.primary,
            ),
            SizedBox(height: 12),
            Text(
              'COREPUNK GUIDES',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Em desenvolvimento (Fase de Guias)...',
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
