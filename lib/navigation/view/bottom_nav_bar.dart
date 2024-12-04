import 'package:flutter/material.dart';
import 'package:zimble/l10n/l10n.dart';

@visibleForTesting
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueSetter<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          key: Key('bottonNavBar_home'),
          label: context.l10n.bottomNavBarHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(
            Icons.search,
            key: Key('bottomNavBar_search'),
          ),
          label: context.l10n.bottomNavBarSearch,
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
