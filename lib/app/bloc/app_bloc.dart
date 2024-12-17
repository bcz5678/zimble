import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required UserRepository userRepository,
    required NotificationsRepository notificationsRepository,
    required User user,
  })  : _userRepository = userRepository,
        _notificationsRepository = notificationsRepository,
        super(
          user == User.anonymous
              ? const AppState.unauthenticated()
              : AppState.authenticated(user),
        ) {
    on<AppUserChanged>(_onUserChanged);
    /// Implement with Onboarding
    //on<AppOnboardingCompleted>(_onOnboardingCompleted);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppDeleteAccountRequested>(_onDeleteAccountRequested);
    on<AppOpened>(_onAppOpened);

    /// Initialize subscription to the _userRepository rxStream for user changes
    _userSubscription = _userRepository.user.listen(_userChanged);

    // [DEBUG TEST]
    if (kDebugMode) {
      print('app_bloc -> _AppBlocInitiation -> ${state.user}');
    }
  }


  /// The number of app opens after which the login overlay is shown
  /// for an unauthenticated user.
  static const _appOpenedCountForLoginOverlay = 5;

  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRepository;

  late StreamSubscription<User> _userSubscription;

  /// callback for _userSubscription events,
  /// calling the on<AppUserChanged> event method below
  void _userChanged(User user) {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('app_bloc -> _userChanged -> $user');
    }
    add(AppUserChanged(user));
  }

  /// Handles updating AppState based on  newly changed User data
  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    if(kDebugMode) {
      print('app_bloc.dart -> _onUSerChanged -> $AppStatus');
    }

    final user = event.user;

    switch (state.status) {
    /// Implement with Onboarding
    //case AppStatus.onboardingRequired:
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
      /*
  /// Implement with Onboarding
  //return user != User.anonymous && user.isNewUser
          ? emit(AppState.onboardingRequired(user))
          : user == User.anonymous
              ? emit(const AppState.unauthenticated())
              : emit(AppState.authenticated(user));

   */
        if (user != User.anonymous && user.id.isNotEmpty) {
          emit(AppState.authenticated(user));
        } else {
          emit(const AppState.unauthenticated());
        }

    }
  }

  /*
  /// Implement with Onboarding
  void _onOnboardingCompleted(
    AppOnboardingCompleted event,
    Emitter<AppState> emit,
  ) {
    if (state.status == AppStatus.onboardingRequired) {
      return state.user == User.anonymous
          ? emit(const AppState.unauthenticated())
          : emit(AppState.authenticated(state.user));
    }
  }
  */

  /// Handles logging out the user in _userRepository on logout event
  /// Will pause notifications when implemented
  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    // We are disabling notifications when a user logs out because
    // the user should not receive any notifications when logged out.

    // [DEBUG TEST]
    if (kDebugMode) {
      print('app_bloc -> _onLogoutRequested -> $event');
    }

    //unawaited(_notificationsRepository.toggleNotifications(enable: false));


    unawaited(_userRepository.logOut());
  }

  ///Handles deleting the user account the user in _userRepository
  ///on delete event
  /// Will stop notifications when implemented
  Future<void> _onDeleteAccountRequested(
      AppDeleteAccountRequested event,
      Emitter<AppState> emit,
      ) async {
    try {
      // We are disabling notifications when a user deletes their account
      // because the user should not receive any notifications after their
      // account is deleted.

      // [DEBUG TEST]
      if (kDebugMode) {
        print('app_bloc -> _onDeleteAccountRequested -> $event');
      }

      //unawaited(_notificationsRepository.toggleNotifications(enable: false));
      await _userRepository.deleteAccount();
    } catch (error, stackTrace) {
      await _userRepository.logOut();
      addError(error, stackTrace);
    }
  }

  /// Tracking how many times the app has been opened
  /// from Local Storage Keys before prompting to re-login
  Future<void> _onAppOpened(AppOpened event, Emitter<AppState> emit) async {
    if (state.user.isAnonymous) {

      // [DEBUG TEST]
      if (kDebugMode) {
        print('app_bloc -> _onAppOpened -> ${state.user}');
        print('app_bloc -> _onAppOpened -> ${event}');
      }

      final appOpenedCount = await _userRepository.fetchAppOpenedCount();

      if (appOpenedCount == _appOpenedCountForLoginOverlay - 1) {
        emit(state.copyWith(showLoginOverlay: true));
      }

      if (appOpenedCount < _appOpenedCountForLoginOverlay + 1) {
        await _userRepository.incrementAppOpenedCount();
      }
    }
  }


  /// Disposing of subscriptions
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
