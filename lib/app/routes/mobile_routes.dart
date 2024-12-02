import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_repository/user_repository.dart';
import 'package:zimble/analytics/analytics.dart' as analytics;
import 'package:zimble/app/app.dart';
import 'package:zimble/error/error.dart';
import 'package:zimble/home/home.dart';
import 'package:zimble/inventory/inventory.dart';
import 'package:zimble/login/login.dart';
import 'package:zimble/readers/readers.dart';
import 'package:zimble/tag_finder/tag_finder.dart';
import 'package:zimble/tag_info/tag_info.dart';
import 'package:zimble/trigger/trigger.dart';


class MobileRouter {

  MobileRouter({
    required AppBloc appBloc,
  }) : _appBloc = appBloc;

  final AppBloc _appBloc;

  GoRouter get router =>
    GoRouter(
      initialLocation: AppRouter.homePath,
      routes: [
        GoRoute(
          path: AppRouter.homePath,
          name: AppRouteNames.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppRouter.loginPath,
          name: AppRouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRouter.loginWithEmailPath,
          name: AppRouteNames.loginWithEmail,
          builder: (context, state) => const LoginWithEmailPage(),
        ),
        GoRoute(
        path: AppRouter.inventoryPath,
        name: AppRouteNames.inventory,
        builder: (context, state) => const InventoryPage(),
        ),
        GoRoute(
          path: AppRouter.readersPath,
          name: AppRouteNames.readers,
          builder: (context, state) => const ReadersPage(),
        ),
        GoRoute(
          path: AppRouter.tagFinderPath,
          name: AppRouteNames.tagFinder,
          builder: (context, state) => const TagFinderPage(),
        ),
        GoRoute(
          path: AppRouter.tagInfoPath,
          name: AppRouteNames.tagInfo,
          builder: (context, state) => const TagInfoPage(),
        ),
        GoRoute(
          path: AppRouter.triggerPath,
          name: AppRouteNames.trigger,
          builder: (context, state) => const TriggerPage(),
        ),

      ],

      errorBuilder: (context, state) => ErrorPage(error: state.error),


      /// Changes on the listenable will cause the router to refresh its route (AUTH)
      refreshListenable: AuthenticatedUserListener(stream: _appBloc.stream),


      /// The top-level callback allows the app to redirect to a new location.
      redirect: (context, state) {


        // if the user is not logged in, they need to login
        final AppStatus authenticationStatus = context.read<AppBloc>().state.status;
        final String loginLocation = AppRouter.loginWithEmailPath;
        final User user =  context.read<AppBloc>().state.user;

        // Grab the location the user is trying to reach,
        // to use as a query parameter on redirect
        final String homeLocation = AppRouter.homePath;

        // Check if the current location  is the Home page, then set it to ''
        // or set fromLocation as the non-home page they were trying to access
        final String fromLocation =
          state.matchedLocation == homeLocation
          ? ''
          : state.matchedLocation;

        //[DEBUG TEST] with tree-shaking to remove tests on release
        if(kDebugMode) {
          print('GoRouter_routes -> redirect -> in MobileRouter Redirect');
          print('AppBloc.stream - ${context.read<AppBloc>().stream.last.toString()}');
          print('authenticationStatus - $authenticationStatus');
          print('loginLocation - $loginLocation');
          print('homeLocation - $homeLocation');
          print('fromLocation - $fromLocation');
          print('matchedLocation - ${state.matchedLocation}');
          print('USER');
          print('Name: ${user.name}');
          print('id: ${user.id}');
          print('email: ${user.email}');
          print('photo: ${user.photo}');
          print('isNewUser: ${user.isNewUser}');
          print('placeholderData: ${user.placeholderData}');
        }


        /// Authentication Redirect Based on Authentication and location
        /// Remarks: Switch case was tried, but not available due to
        /// non-constant expressions like loginLocation as a condition

        if (authenticationStatus == AppStatus.unauthenticated) {
          //Authentication Status: not logged in

          if (state.matchedLocation == loginLocation) {
            // User already on Login Page, no need to redirect
            return null;

          } else {

            // Redirect User to the Login Page, passing the current URL location
            // as a param in state to redirect after successful login
            return state.namedLocation(
              AppRouteNames.loginWithEmail,
              queryParameters: {
                if (fromLocation.isNotEmpty) 'from': fromLocation
              },
            );
          }
        }

        else if (authenticationStatus == AppStatus.authenticated) {
          //Authentication Status: not logged in

          // User just logged in (on login Page),
          // DOES THIS CODE NEED TO MOVE TO AUTH BLOC?
          if (state.matchedLocation == loginLocation) {

            // Firing Analytics event for tracking
            context.read<analytics.AnalyticsBloc>().add(
              analytics.TrackAnalyticsEvent(
                user.isNewUser
                    ? analytics.RegistrationEvent()
                    : analytics.LoginEvent(),
              ),
            );
          }

          //Redirect them to previous destination
          // (or home if they weren't going anywhere)
          return state.uri.queryParameters['from'] ?? homeLocation;

        } else {
          // AppStatus not set - returns null
          return null;
        }

        //Default fail-safe in case nothing
        return null;
      },
    );

}
