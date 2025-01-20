import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zimble/app/routes/routes.dart';
import 'package:zimble/l10n/l10n.dart';

@visibleForTesting
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  final List<RouteDataModel> navBarList = [
    AppRoutes.home,
    AppRoutes.inventory,
    AppRoutes.readers,
    AppRoutes.tagFinder,
    AppRoutes.tagScan,
    AppRoutes.trigger,
  ];

  void _onItemTapped(BuildContext context, int index){
    GoRouter.of(context).goNamed(navBarList[index].name);
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    late RouteDataModel selectedRoute;
    late int selectedIndex = 0;

    // Testing start of the current location route against the list
    // This will account for any deeplinking that comes directly to the app/site
    if (location == '/') {
      return 0;
    } else {
      for(var i = 0; i < navBarList.length; i++ ) {
        if (location != '/' && location.startsWith(navBarList[i].path)) {
          selectedRoute = navBarList[i];
          selectedIndex = i;
        }
      }
    }

    return selectedIndex;
  }
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: Key("bottonNavBar_main"),
      backgroundColor: AppColors.lingoDark_100,
      selectedItemColor: AppColors.lingoOrange_100,
      unselectedItemColor: AppColors.lingoBlack_40,
      showUnselectedLabels: true,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 30,
      items: [
        BottomNavigationBarItem(
          key: Key('bottonNavBarItem_home'),
          icon: Icon(Icons.home),
          label: context.l10n.bottomNavBarHome,
        ),
        BottomNavigationBarItem(
          key: Key('bottomNavBarItem_inventory'),
          icon: const Icon(Icons.inventory),
          label: context.l10n.bottomNavBarInventory,
        ),
        BottomNavigationBarItem(
          key: Key('bottomNavBarItem_readers'),
          icon: const Icon(Icons.barcode_reader),
          label: context.l10n.bottomNavBarReaders,
        ),
        BottomNavigationBarItem(
          key: Key('bottomNavBarItem_tagFinder'),
          icon: const Icon(Icons.list),
          label: context.l10n.bottomNavBarTagFinder,
        ),
        BottomNavigationBarItem(
          key: Key('bottomNavBarItem_tagInfo'),
          icon: const Icon(Icons.assignment),
          label: context.l10n.bottomNavBarTagInfo,
        ),
        BottomNavigationBarItem(
          key: Key('bottomNavBarItem_trigger'),
          icon: const Icon(Icons.ads_click),
          label: context.l10n.bottomNavBarTrigger,
        ),
      ],
      currentIndex: _calculateSelectedIndex(context),
      onTap: (index) {
        _onItemTapped(context, index);
      },
    );
  }
}
