import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/app/app.dart';
import 'package:zimble/home/home.dart';
import 'package:zimble/login/login.dart';
import 'package:zimble/navigation/navigation.dart';
import 'package:zimble/user_profile/user_profile.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double? scrolledUnderElevation;
  bool shadowColor = false;

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
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppRoutes.home.title ?? 'Home'),
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
              UserProfileButton()
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
                    Text(
                      context.read<AppBloc>().state.user.toString(),
                    ),
                  ],
                ),
              )
          ),
        ),
    );
  }
}