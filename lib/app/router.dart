import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/trips/presentation/trips_screen.dart';
import '../features/trips/presentation/shared_trips_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/trips',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/trips', builder: (c, s) => const TripsScreen()),
        GoRoute(path: '/shared', builder: (c, s) => const SharedTripsScreen()),
        GoRoute(path: '/search', builder: (c, s) => const SearchScreen()),
        GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
      ],
    ),
  ],
);

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: location.startsWith('/shared')
            ? 1
            : location.startsWith('/search')
                ? 2
                : location.startsWith('/settings')
                    ? 3
                    : 0,
        onDestinationSelected: (i) {
          if (i == 0) context.go('/trips');
          if (i == 1) context.go('/shared');
          if (i == 2) context.go('/search');
          if (i == 3) context.go('/settings');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map), label: 'Маршруты'),
          NavigationDestination(icon: Icon(Icons.public), label: 'Общие'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Поиск'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Настройки'),
        ],
      ),
    );
  }
}
