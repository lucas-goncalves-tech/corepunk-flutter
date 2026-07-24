import 'package:fluent_ui/fluent_ui.dart';

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

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: _currentIndex,
        onChanged: (index) {
          setState(() => _currentIndex = index);
        },
        displayMode: PaneDisplayMode.auto,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.database),
            title: const Text('Itens'),
            body: const ItemsPage(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.build),
            title: const Text('Builds'),
            body: const BuildsPage(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.library),
            title: const Text('Guias'),
            body: const GuidesPage(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.map_pin),
            title: const Text('Mapa'),
            body: const MapsPage(),
          ),
        ],
      ),
    );
  }
}
