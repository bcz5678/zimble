import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/app/app.dart';
import 'package:zimble/login/view/login_modal.dart';
import 'package:zimble/navigation/navigation.dart';
import 'package:zimble/user_profile/user_profile.dart';

class TagInfoView extends StatefulWidget {
  const TagInfoView({super.key});

  @override
  State<TagInfoView> createState() => _TagInfoViewState();
}

class _TagInfoViewState extends State<TagInfoView> {
  double? scrolledUnderElevation;
  bool shadowColor = false;


  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppRoutes.tagInfo.title ?? 'Tag Info'),
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
          actions: const [
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
                  Placeholder()
                ],
              ),
            )
        ),
      ),
    );
  }
}
