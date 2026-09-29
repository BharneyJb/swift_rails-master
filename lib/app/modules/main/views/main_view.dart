import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../config/theme/app_colors.dart';
import '../../home/views/home_view.dart';
import '../../search/views/search_view.dart';
import '../../tickets/views/my_tickets_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  // One Navigator key per tab so we can query/pop each tab's stack.
  static final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), // Search
    GlobalKey<NavigatorState>(), // Tickets
    GlobalKey<NavigatorState>(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      NavigatorPage(navigatorKey: _navigatorKeys[0], child: const HomeView()),
      NavigatorPage(navigatorKey: _navigatorKeys[1], child: const SearchView()),
      NavigatorPage(navigatorKey: _navigatorKeys[2], child: const MyTicketsView()),
      NavigatorPage(navigatorKey: _navigatorKeys[3], child: const ProfileView()),
    ];

    return PopScope(
      // Never let the system handle the back press automatically.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final int index = controller.currentIndex.value;
        final NavigatorState? tabNav = _navigatorKeys[index].currentState;

        // 1. If the current tab has inner routes, pop them first.
        if (tabNav != null && tabNav.canPop()) {
          tabNav.pop();
          return;
        }

        // 2. Not on the Home tab → go to Home.
        if (index != 0) {
          controller.changePage(0);
          return;
        }

        // 3. Already on Home → double-tap to exit.
        final bool shouldExit = await controller.onHomeBackPress();
        if (shouldExit) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Obx(() => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        )),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home),
              activeIcon: Icon(Iconsax.home_15),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.search_normal),
              activeIcon: Icon(Iconsax.search_normal_1),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.ticket),
              activeIcon: Icon(Iconsax.ticket_25),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.user),
              activeIcon: Icon(Iconsax.user_octagon5),
              label: 'Profile',
            ),
          ],
        )),
      ),
    );
  }
}

class NavigatorPage extends StatelessWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const NavigatorPage({
    super.key,
    required this.navigatorKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => child,
          settings: settings,
        );
      },
    );
  }
}
