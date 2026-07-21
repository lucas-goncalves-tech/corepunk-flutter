import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CorepunkHeaderWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const CorepunkHeaderWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      titleSpacing: 16,
      elevation: 0,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(height: 1.0, thickness: 1.0, color: AppColors.border),
      ),
      title: Row(
        children: [
          _buildLogoIcon(),
          const SizedBox(width: 12),
          _buildTitleText(),
        ],
      ),
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppColors.borderRadius,
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: const Icon(
        Icons.shield_outlined,
        color: AppColors.primary,
        size: 18,
      ),
    );
  }

  Widget _buildTitleText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COREPUNK MOBILE',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'DATABASE & TOOLS',
          style: TextStyle(
            color: AppColors.mutedForeground,
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
