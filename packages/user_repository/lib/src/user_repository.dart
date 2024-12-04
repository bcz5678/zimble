import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:authentication_client/authentication_client.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:storage/storage.dart';
import 'package:user_repository/user_repository.dart';

part 'user_storage.dart';

/// {@template user_failure}
/// A base failure for the user repository failures.
/// {@endtemplate}
abstract class UserFailure with EquatableMixin implements Exception {
  /// {@macro user_failure}
  const UserFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template fetch_app_opened_count_failure}
/// Thrown when fetching app opened count fails.
/// {@endtemplate}
class FetchAppOpenedCountFailure extends UserFailure {
  /// {@macro fetch_app_opened_count_failure}
  const FetchAppOpenedCountFailure(super.error);
}

/// {@template increment_app_opened_count_failure}
/// Thrown when incrementing app opened count fails.
/// {@endtemplate}
class IncrementAppOpenedCountFailure extends UserFailure {
  /// {@macro increment_app_opened_count_failure}
  const IncrementAppOpenedCountFailure(super.error);
}

/// {@template fetch_current_subscription_failure}
/// An exception thrown when fetching current subscription fails.
/// {@endtemplate}
class FetchCurrentSubscriptionFailure extends UserFailure {
  /// {@macro fetch_current_subscription_failure}
  const FetchCurrentSubscriptionFailure(super.error);
}

/// {@template user_repository}
/// Repository which manages the user domain.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({
    //required FlutterNewsExampleApiClient apiClient,
    required AuthenticationClient authenticationClient,
    required PackageInfoClient packageInfoClient,
    required DeepLinkService deepLinkService,
    required UserStorage storage,
  })  : //_apiClient = apiClient,
        _authenticationClient = authenticationClient,
        _packageInfoClient = packageInfoClient,
        _deepLinkService = deepLinkService,
        _storage = storage;

  //final FlutterNewsExampleApiClient _apiClient;
  final AuthenticationClient _authenticationClient;
  final PackageInfoClient _packageInfoClient;
  final DeepLinkService _deepLinkService;
  final UserStorage _storage;

  /// Stream of [User] which will emit the current user when
  /// the authentication state or the subscription plan changes.
  ///
  ///
  /*
  ///  Example for combining 2 sources to stream
  /// - Will be useful to combine Firebase User with DB profile stores
  Stream<User> get user =>
      Rx.combineLatest2<AuthenticationUser, SubscriptionPlan, User>(
        _authenticationClient.user,
        _currentSubscriptionPlanSubject.stream,
            (authenticationUser, subscriptionPlan) => User.fromAuthenticationUser(
          authenticationUser: authenticationUser,
          subscriptionPlan: authenticationUser != AuthenticationUser.anonymous
              ? subscriptionPlan
              : SubscriptionPlan.none,
        ),
      ).asBroadcastStream();
  */

  /// Getter for current user.
  /// **NOTE: This version is only being used to bootstrap getting the app up and running
  /// Will be replaced by an Rx.combineLatest2 or greater when more userProfile info is added.
  Stream<User> get user {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('user_repository -> get user -> Entry');
    }
    return Rx.combineLatest2<AuthenticationUser, String, User>(
      _authenticationClient.user,
      _placeholderData,
          (authenticationUser, placeholderData) =>
          User.fromAuthenticationUser(
            authenticationUser: authenticationUser,
          ),
    ).asBroadcastStream();
  }

  final BehaviorSubject<String> _placeholderData = BehaviorSubject.seeded('null');


  /// A stream of incoming email links used to authenticate the user.
  ///
  /// Emits when a new email link is emitted on [DeepLinkClient.deepLinkStream],
  /// which is validated using [AuthenticationClient.isLogInWithEmailLink].
  Stream<Uri> get incomingEmailLinks => _deepLinkService.deepLinkStream.where(
        (deepLink) => _authenticationClient.isLogInWithEmailLink(
      emailLink: deepLink.toString(),
    ),
  );

  /// Starts the Sign In with Apple Flow.
  ///
  /// Throws a [LogInWithAppleFailure] if an exception occurs.
  Future<void> logInWithApple() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('user_repository -> logInWithApple -> Entry');
    }
    try {
      await _authenticationClient.logInWithApple();
    } on LogInWithAppleFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithAppleFailure(error), stackTrace);
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithGoogleCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithGoogleFailure] if an exception occurs.
  Future<void> logInWithGoogle() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('user_repository -> logInWithGoogle -> Entry');
    }
    try {
      await _authenticationClient.logInWithGoogle();
    } on LogInWithGoogleFailure {
      rethrow;
    } on LogInWithGoogleCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithGoogleFailure(error), stackTrace);
    }
  }

  /*
  /// Starts the Sign In with Twitter Flow.
  ///
  /// Throws a [LogInWithTwitterCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithTwitterFailure] if an exception occurs.
  Future<void> logInWithTwitter() async {
    try {
      await _authenticationClient.logInWithTwitter();
    } on LogInWithTwitterFailure {
      rethrow;
    } on LogInWithTwitterCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithTwitterFailure(error), stackTrace);
    }
  }

   */

  /*
  /// Starts the Sign In with Facebook Flow.
  ///
  /// Throws a [LogInWithFacebookCanceled] if the flow is canceled by the user.
  /// Throws a [LogInWithFacebookFailure] if an exception occurs.
  Future<void> logInWithFacebook() async {
    try {
      await _authenticationClient.logInWithFacebook();
    } on LogInWithFacebookFailure {
      rethrow;
    } on LogInWithFacebookCanceled {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithFacebookFailure(error), stackTrace);
    }
  }
   */

  /// Sends an authentication link to the provided [email].
  ///
  /// Throws a [SendLoginEmailLinkFailure] if an exception occurs.
  Future<void> sendLoginEmailLink({
    required String email,
  }) async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('user_repository -> sendLoginEmailLink -> Entry');
    }

    try {
      await _authenticationClient.sendLoginEmailLink(
        email: email,
        appPackageName: _packageInfoClient.packageName,
      );
    } on SendLoginEmailLinkFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SendLoginEmailLinkFailure(error), stackTrace);
    }
  }

  /// Signs in with the provided [email] and [emailLink].
  ///
  /// Throws a [LogInWithEmailLinkFailure] if an exception occurs.
  Future<void> logInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('user_repository -> loginWithEmailLink -> Entry');
    }

    try {
      await _authenticationClient.logInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );
    } on LogInWithEmailLinkFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithEmailLinkFailure(error), stackTrace);
    }
  }

  /// Signs in with the provided [email] and [emailLink].
  ///
  /// Throws a [LogInWithEmailLinkFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {

      // [DEBUG TEST]
      if (kDebugMode) {
        print('user_repository -> loginWithEmailAndPassword -> Entry');
      }
    try {
      await _authenticationClient.logInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on LogInWithEmailAndPasswordFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithEmailAndPasswordFailure(error), stackTrace);
    }
  }

  /// Signs out the current user which will emit
  /// [User.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('user_repository -> logout -> Entry');
    }

    try {
      await _authenticationClient.logOut();
    } on LogOutFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Deletes the current user account.
  Future<void> deleteAccount() async {
    // [DEBUG TEST]
    if (kDebugMode) {
      print('user_repository -> deleteAccount -> Entry');
    }
    try {
      await _authenticationClient.deleteAccount();
    } on DeleteAccountFailure {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteAccountFailure(error), stackTrace);
    }
  }

  /// Returns the number of times the app was opened.
  Future<int> fetchAppOpenedCount() async {

    // [DEBUG TEST]
    if (kDebugMode) {
      print('user_repository -> fetchAppOpenedCount -> Entry');
    }
    try {
      return await _storage.fetchAppOpenedCount();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchAppOpenedCountFailure(error),
        stackTrace,
      );
    }
  }

  /// Increments the number of times the app was opened by 1.
  Future<void> incrementAppOpenedCount() async {
    try {
      final value = await fetchAppOpenedCount();
      final result = value + 1;
      await _storage.setAppOpenedCount(count: result);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        IncrementAppOpenedCountFailure(error),
        stackTrace,
      );
    }
  }

}
