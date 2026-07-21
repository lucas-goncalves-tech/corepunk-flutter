import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CorepunkHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
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
      actions: const [_StatusBadge(), SizedBox(width: 16)],
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
      child: const Icon(Icons.shield_outlined, color: AppColors.primary, size: 18),
    );
  }

  Widget _buildTitleText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COREPUNK HELP',
          style: TextStyle(color: AppColors.primary, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          'BANCO DE DADOS & FERRAMENTAS',
          style: TextStyle(color: AppColors.mutedForeground, fontSize: 9, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: Colors.greenAccent),
          SizedBox(width: 6),
          Text(
            'ONLINE',
            style: TextStyle(color: AppColors.mutedForeground, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
