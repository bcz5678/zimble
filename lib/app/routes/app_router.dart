import 'package:equatable/equatable.dart';

/// RouteData class definition at end

class AppRouter {
  final home = const RouteData(
    name: 'home',
    path: '/',
    title: 'Home',
  );
  final loginWithEmail = const RouteData(
    name: 'loginWithEmail',
    path: '/login_with_email',
    title: 'Login with Email',
  );
  final login = const RouteData(
    name: 'login',
    path: '/login',
    title: 'Login',
  );
  final inventory = const RouteData(
    name: 'inventory',
    path: '/inventory',
    title: 'Inventory',
  );
  final readers = const RouteData(
    name: 'readers',
    path: '/readers',
    title: 'Readers',
  );
  final tagFinder = const RouteData(
    name: 'tagFinder',
    path: '/tag_finder',
    title: 'Tag Finder',
  );
  final tagInfo = const RouteData(
    name: 'tagInfo',
    path: '/tag_info',
    title: 'Tag Info',
  );
  final trigger = const RouteData(
    name: 'trigger',
    path: '/trigger',
    title: 'Trigger',
  );
}


class RouteData extends Equatable{
  const RouteData({
    required this.name,
    required this.path,
    this.title,
  });

  final String name;
  final String path;
  final String? title;

  @override
  List<Object?> get props {
    return [
      name,
      path,
      title,
    ];
  }
}
