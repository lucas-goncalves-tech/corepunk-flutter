import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../items/presentation/pages/items_page.dart';
import '../../../builds/presentation/pages/builds_page.dart';
import '../../../guides/presentation/pages/guides_page.dart';
import '../../../maps/presentation/pages/maps_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ItemsPage(),
    BuildsPage(),
    GuidesPage(),
    MapsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1.0)),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: AppColors.card,
            indicatorColor: AppColors.primary.withValues(alpha: 0.2),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                );
              }
              return const TextStyle(
                color: AppColors.mutedForeground,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const IconThemeData(color: AppColors.primary, size: 22);
              }
              return const IconThemeData(
                color: AppColors.mutedForeground,
                size: 22,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: 'Itens',
              ),
              NavigationDestination(
                icon: Icon(Icons.build_circle_outlined),
                selectedIcon: Icon(Icons.build_circle),
                label: 'Builds',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book),
                label: 'Guias',
              ),
              NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: 'Mapa',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
