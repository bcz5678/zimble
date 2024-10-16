import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/app/app.dart';
import 'package:zimble/home/home.dart';
import 'package:zimble/login/login.dart';
import 'package:zimble/inventory/inventory.dart';
import 'package:zimble/readers/readers.dart';
import 'package:zimble/tag_finder/tag_finder.dart';
import 'package:zimble/tag_info/tag_info.dart';
import 'package:zimble/trigger/trigger.dart';
import 'package:zimble/user_profile/user_profile.dart';
import 'package:zimble/navigation/navigation.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double? scrolledUnderElevation;

  bool shadowColor = false;

  final List<Widget> _tabs = [
    HomePage(),
    InventoryPage(),
    ReadersPage(),
    TagFinderPage(),
    TagInfoPage(),
    TriggerPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AppBloc, AppState>(
            listenWhen: (previous, current) =>
            previous.showLoginOverlay != current.showLoginOverlay,
            listener: (context, state) {
              if (state.showLoginOverlay) {
                showAppModal<void>(
                  context: context,
                  builder: (context) => const LoginModal(),
                  routeSettings: const RouteSettings(name: LoginModal.name),
                );
              }
            },
          ),
          BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            titleTextStyle: UITextStyle.headline1,
            scrolledUnderElevation: scrolledUnderElevation,
            centerTitle: true,
            backgroundColor: AppColors.lingoDark,
            leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                }),
            actions: [
                     const UserProfileButton()
            ],
          ),
          drawer: Drawer(
            width: MediaQuery.of(context).size.width * .85,
            child: const NavDrawer(),
          ),

          body: Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                  ],
                ),
              )
          ),
        ),
    );
  }
}