import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const NavigatorPage(child: HomeView()),
      const NavigatorPage(child: SearchView()),
      const NavigatorPage(child: MyTicketsView()),
      const NavigatorPage(child: ProfileView()),
    ];

    return Scaffold(
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
    );
  }
}

class NavigatorPage extends StatelessWidget {
  final Widget child;
  const NavigatorPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => child,
          settings: settings,
        );
      },
    );
  }
}
