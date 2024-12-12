import 'package:zimble/app/routes/routes.dart';

/// AppRouter Route Definitions for routing
/// RouteData class definition at end

class AppRoutes {

  static RouteDataModel home = RouteDataModel(
    name: 'home',
    path: '/',
    title: 'Home',
  );
  static RouteDataModel loginWithEmail = RouteDataModel(
    name: 'loginWithEmail',
    path: '/login_with_email',
    title: 'Login with Email',
  );
  static RouteDataModel login = RouteDataModel(
    name: 'login',
    path: '/login',
    title: 'Login',
  );
  static RouteDataModel dash = RouteDataModel(
    name: 'dash',
    path: '/dash',
    title: 'Dashboard',
  );
  static RouteDataModel inventory = RouteDataModel(
    name: 'inventory',
    path: '/inventory',
    title: 'Inventory',
  );
  static RouteDataModel readers = RouteDataModel(
    name: 'readers',
    path: '/readers',
    title: 'Readers',
  );

  /*
  static RouteDataModel readersCurrentInfo = RouteDataModel(
    name: 'readersCurrentInfo',
    path: '/readers/current',
    title: 'Current Reader Info',
  );
  static RouteDataModel readersSaved = RouteDataModel(
    name: 'readersSaved',
    path: '/readers/saved',
    title: 'Saved Readers',
  );
  static RouteDataModel readersConnectNew = RouteDataModel(
    name: 'readersConnectNew',
    path: 'readers/connect_new',
    title: 'Connect New Readers',
  );
  static RouteDataModel readersConnectNewPaired = RouteDataModel(
    name: 'readersConnectNewPaired',
    path: 'readers/connect_new/paired',
    title: 'Paired Readers',
  );
  static RouteDataModel readersConnectNewScan = RouteDataModel(
    name: 'readersConnectNewScan',
    path: 'readers/connect_new/scan',
    title: 'Scan For New Readers',
  );
   */
  static RouteDataModel tagFinder = RouteDataModel(
    name: 'tagFinder',
    path: '/tag_finder',
    title: 'Tag Finder',
  );
  static RouteDataModel tagInfo = RouteDataModel(
    name: 'tagInfo',
    path: '/tag_info',
    title: 'Tag Info',
  );
  static RouteDataModel trigger = RouteDataModel(
    name: 'trigger',
    path: '/trigger',
    title: 'Trigger',
  );
}
