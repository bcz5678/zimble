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
  final AppRouter _appRouter = AppRouter();

  GoRouter get router =>
    GoRouter(
      initialLocation: _appRouter.home.path,
      routes: [
        GoRoute(
          path: _appRouter.home.path,
          name: _appRouter.home.name,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: _appRouter.login.path,
          name: _appRouter.login.name,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: _appRouter.loginWithEmail.path,
          name: _appRouter.loginWithEmail.name,
          builder: (context, state) => const LoginWithEmailPage(),
        ),
        GoRoute(
        path: _appRouter.inventory.path,
        name: _appRouter.inventory.name,
        builder: (context, state) => const InventoryPage(),
        ),
        GoRoute(
          path: _appRouter.readers.path,
          name: _appRouter.readers.name,
          builder: (context, state) => const ReadersPage(),
        ),
        GoRoute(
          path: _appRouter.tagFinder.path,
          name: _appRouter.tagFinder.name,
          builder: (context, state) => const TagFinderPage(),
        ),
        GoRoute(
          path: _appRouter.tagInfo.path,
          name: _appRouter.tagInfo.name,
          builder: (context, state) => const TagInfoPage(),
        ),
        GoRoute(
          path: _appRouter.trigger.path,
          name: _appRouter.trigger.name,
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
        final String loginLocation = _appRouter.loginWithEmail.path;
        final User user =  context.read<AppBloc>().state.user;

        // Grab the location the user is trying to reach,
        // to use as a query parameter on redirect
        final String homeLocation = _appRouter.home.path;

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

          if (kDebugMode) {
            print('mobile_routes -> redirection -> not authenticated');
          }

          if (state.matchedLocation == loginLocation) {
            // User already on Login Page, no need to redirect

            if (kDebugMode) {
              print('mobile_routes -> redirection -> not authenticated  && loginLocation');
            }

            return null;

          } else {

            if (kDebugMode) {
              print('mobile_routes -> redirection -> not authenticated  && fromLocation');
            }
            // Redirect User to the Login Page, passing the current URL location
            // as a param in state to redirect after successful login
            return state.namedLocation(
              _appRouter.loginWithEmail.name,
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
            if (kDebugMode) {
              print('mobile_routes -> redirection -> authenticated & loginLocation');
            }

            // Firing Analytics event for tracking
            context.read<analytics.AnalyticsBloc>().add(
              analytics.TrackAnalyticsEvent(
                user.isNewUser
                    ? analytics.RegistrationEvent()
                    : analytics.LoginEvent(),
              ),
            );
          }

          if (kDebugMode) {
            print('mobile_routes -> redirection -> authenticated & fromLocation');
            print('{state.uri.queryParameters["from"] -> ${state.uri.queryParameters['from']}');
          }

          //Redirect them to previous destination
          // (or home if they weren't going anywhere)
          return state.matchedLocation;

        } else {
          // AppStatus not set - returns null
          if (kDebugMode) {
            print('mobile_routes -> redirection -> return null from no auth match');
          }
          return null;
        }

      },
    );

}
