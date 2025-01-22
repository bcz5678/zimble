import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/app/app.dart';
import 'package:zimble/app/view/app.dart';
import 'package:zimble/l10n/l10n.dart';
import 'package:zimble/login/view/login_modal.dart';
import 'package:zimble/navigation/navigation.dart';
import 'package:zimble/user_profile/user_profile.dart';

import 'package:zimble/tag_scan/tag_scan.dart';

class TagScanView extends StatefulWidget {
  const TagScanView({super.key});

  @override
  State<TagScanView> createState() => _TagScanViewState();
}

class _TagScanViewState extends State<TagScanView> {
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
          title: Text(AppRoutes.tagScan.title ?? 'Tag Scan'),
          titleTextStyle: UITextStyle.headline1,
          scrolledUnderElevation: scrolledUnderElevation,
          centerTitle: true,
          backgroundColor: AppColors.lingoDark_100,
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
          width: MediaQuery
              .of(context)
              .size
              .width * .85,
          child: const NavDrawer(),
        ),

        body: Container(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<TagScanBloc, TagScanState>(
              builder: (context, state) {
                return Center(
                  child: Column(
                    children: [
                      TagScanScreen()
                    ],
                  ),
                );
              },
            )
        ),
      ),
    );
  }
}


class TagScanScreen extends StatefulWidget {
  const TagScanScreen({super.key});

  @override
  State<TagScanScreen> createState() => _TagScanScreenState();
}

class _TagScanScreenState extends State<TagScanScreen> {
  late bool _scanButtonState = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              _scanButtonState
              ? context.read<TagScanBloc>().add(TagScanStop())
              : context.read<TagScanBloc>().add(TagScanStart());

              setState(() {
                _scanButtonState = !_scanButtonState;
              });
            },
            child: _scanButtonState
                ? Text(
              context.l10n.tagScanButtonStopScan,
            )
                : Text(
              context.l10n.tagScanButtonStartScan,
            )
        )
      ],
    );
  }
}

