import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/corepunk_header_widget.dart';
import '../widgets/category_selector_widget.dart';
import '../widgets/item_filter_bar_widget.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  String _selectedCategory = '';
  String _searchQuery = '';
  String _selectedQuality = '';
  String _selectedTier = '';
  String _selectedProfession = '';
  String _selectedMastery = '';

  void _resetFilters() {
    setState(() {
      _searchQuery = '';
      _selectedQuality = '';
      _selectedTier = '';
      _selectedProfession = '';
      _selectedMastery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CorepunkHeaderWidget(),
      body: Column(
        children: [
          CategorySelectorWidget(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          ItemFilterBarWidget(
            searchQuery: _searchQuery,
            selectedQuality: _selectedQuality,
            selectedTier: _selectedTier,
            selectedProfession: _selectedProfession,
            selectedMastery: _selectedMastery,
            onSearchChanged: (query) => setState(() => _searchQuery = query),
            onQualityChanged: (quality) => setState(() => _selectedQuality = quality),
            onTierChanged: (tier) => setState(() => _selectedTier = tier),
            onProfessionChanged: (prof) => setState(() => _selectedProfession = prof),
            onMasteryChanged: (mastery) => setState(() => _selectedMastery = mastery),
            onResetFilters: _resetFilters,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.tune_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'FILTROS ATIVOS PARA A API',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterBadge('Tipo (Categoria)', _selectedCategory.isEmpty ? 'Todos' : _selectedCategory),
                  _buildFilterBadge('Busca por Nome', _searchQuery.isEmpty ? 'Nenhuma' : _searchQuery),
                  _buildFilterBadge('Qualidade', _selectedQuality.isEmpty ? 'Todas' : _selectedQuality),
                  _buildFilterBadge('Tier', _selectedTier.isEmpty ? 'Todos' : 'Tier $_selectedTier'),
                  _buildFilterBadge('Profissão', _selectedProfession.isEmpty ? 'Todas' : _selectedProfession),
                  _buildFilterBadge('Classe (Mastery)', _selectedMastery.isEmpty ? 'Todas' : _selectedMastery),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBadge(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppColors.borderRadius,
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.foreground,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
