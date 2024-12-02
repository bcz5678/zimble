import 'dart:async';

import 'package:flutter/foundation.dart';

class AuthenticatedUserListener extends ChangeNotifier {
  AuthenticatedUserListener({
    required Stream<dynamic> stream
  }) {

    //[DEBUG TEST] with tree-shaking to remove tests on release
    if(kDebugMode) {
      print('authenticated_user_listener -> Entry');
    }

    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}