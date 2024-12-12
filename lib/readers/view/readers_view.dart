import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/app/app.dart';
import 'package:zimble/l10n/l10n.dart';
import 'package:zimble/login/view/login_modal.dart';
import 'package:zimble/navigation/navigation.dart';
import 'package:zimble/readers/readers.dart';
import 'package:zimble/user_profile/user_profile.dart';

class ReadersView extends StatefulWidget {
  const ReadersView({super.key});

  @override
  State<ReadersView> createState() => _ReadersViewState();
}

class _ReadersViewState extends State<ReadersView>
    with TickerProviderStateMixin {
  late TabController _tabControllerMain;
  double? scrolledUnderElevation;
  bool shadowColor = false;
  late List<Tab> topNavTabs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    topNavTabs = _buildTopNavTabsList(context);
    _tabControllerMain = TabController(
        vsync: this,
        length: topNavTabs.length
    );
  }

  @override
  void dispose() {
    _tabControllerMain.dispose();
    super.dispose();
  }


  List<Tab> _buildTopNavTabsList(BuildContext context) {
    return [
      Tab(
        icon: const Icon(Icons.flight),
        text: context.l10n.readersMainTabCurrent,
      ),
      Tab(
        icon: const Icon(Icons.app_shortcut),
        text: context.l10n.readersMainTabSaved,
      ),
      Tab(
        icon: const Icon(Icons.settings_remote),
        text: context.l10n.readersMainTabConnectNew,
      ),
    ];
  }


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
      child: DefaultTabController(
        length: topNavTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppRoutes.readers.title ?? 'Readers'),
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
              UserProfileButton(),
            ],
          ),
          drawer: Drawer(
            width: MediaQuery
                .of(context)
                .size
                .width * .85,
            child: const NavDrawer(),
          ),
          body: Column(
            children:[
              Container(
                color: AppColors.lingoWhite,
                child: TabBar(
                  controller: _tabControllerMain,
                  indicatorColor: AppColors.lingoOrange_100,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  labelStyle: TextStyle(
                    color: AppColors.lingoOrange_100,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: AppColors.grey,
                  ),
                  tabs: topNavTabs,
                ),
              ),
              Expanded(
                  child: TabBarView(
                    controller: _tabControllerMain,
                    children: [
                      CurrentReadersScreen(),
                      SavedReadersScreen(),
                      ConnectNewReadersScreen(),
                    ],
                  ),
              )
            ],
          )
        ),
      ),
    );
  }
}
