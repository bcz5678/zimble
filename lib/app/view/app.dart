import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zimble/analytics/analytics.dart';
import 'package:zimble/app/app.dart';
import 'package:zimble/l10n/l10n.dart';
import 'package:zimble/login/login.dart';


class App extends StatelessWidget {
  const App({
    required UserRepository userRepository,
    required NotificationsRepository notificationsRepository,
    required AnalyticsRepository analyticsRepository,
    required User user,
    super.key
  })
      : _userRepository = userRepository,
        _notificationsRepository = notificationsRepository,
        _analyticsRepository = analyticsRepository,
        _user = user;

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRepository;
  final AnalyticsRepository _analyticsRepository;
  final User _user;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: _userRepository),
          RepositoryProvider.value(value: _notificationsRepository),
          RepositoryProvider.value(value: _analyticsRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AppBloc(
                userRepository: _userRepository,
                notificationsRepository: _notificationsRepository,
                user: _user,
              )..add(const AppOpened()),
            ),
            /*
            /// TO IMPLEMENT
            BlocProvider(create: (_) => ThemeModeBloc()),
             */
            BlocProvider(
              create: (_) => LoginWithEmailLinkBloc(
                userRepository: _userRepository,
              ),
              lazy: false,
            ),
            BlocProvider(
              create: (context) => AnalyticsBloc(
                analyticsRepository: _analyticsRepository,
                userRepository: _userRepository,
              ),
              lazy: false,
            ),
          ],
          child: AppView(),
        )
    );
  }
}


class AppView extends StatefulWidget {
  AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    final router = MobileRouter(
      appBloc: BlocProvider.of<AppBloc>(context),
    ).router;

    return MaterialApp.router(
      debugShowCheckedModeBanner: true,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      themeMode: ThemeMode.light,
      /*
    TO Replace theme below
    theme: const AppTheme().themeData,
    darkTheme: const AppDarkTheme().themeData,
     */

      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
