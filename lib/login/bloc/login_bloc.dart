import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<SendEmailLinkSubmitted>(_onSendEmailLinkSubmitted);
    on<LoginEmailAndPasswordSubmitted>(_onEmailAndPasswordSubmitted);
    on<LoginGoogleSubmitted>(_onGoogleSubmitted);
    on<LoginAppleSubmitted>(_onAppleSubmitted);
    on<LoginPasswordChanged>(_onPasswordChanged);
    //on<LoginTwitterSubmitted>(_onTwitterSubmitted);
    //on<LoginFacebookSubmitted>(_onFacebookSubmitted);
  }

  /// UserRepository that holds current UserState and Info
  final UserRepository _userRepository;

  /// [METHOD] tracks state of typing changes to the email input
  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        emailValid: Formz.validate([email]),
      ),
    );
  }

  /// [METHOD] tracks state of typing changes to the password input
  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        passwordValid: Formz.validate([password]),
      ),
    );
  }

  /// [METHOD] Async submission of email input to force move to MagicEmailLink
  /// Not Used currently
  Future<void> _onSendEmailLinkSubmitted(
    SendEmailLinkSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(errorMessage: ''));

    if (!state.emailValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.sendLoginEmailLink(
        email: state.email.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: error.toString()));
      addError(error, stackTrace);
    }
  }

  /// [METHOD] Async login submission of email/password input
  Future<void> _onEmailAndPasswordSubmitted(
      LoginEmailAndPasswordSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    emit(state.copyWith(errorMessage: ''));

    //[DEBUG TEST] with tree-shaking to remove tests on release
    if (kDebugMode) {
      print("login_bloc ->  _onEmailAndPasswordSubmitted -> Entry");
    }

    if (!state.emailValid || !state.passwordValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      //[DEBUG TEST] with tree-shaking to remove tests on release
      if (kDebugMode) {
        print('login_bloc -> _onEmailAndPasswordSubmitted -> Error -> $error');
      }

      emit(state.copyWith(status: FormzSubmissionStatus.failure,
          errorMessage: error.toString()));
      addError(error, stackTrace);
    }
  }

  /// [METHOD] Async login submission of Google OAUTH
  Future<void> _onGoogleSubmitted(
    LoginGoogleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(errorMessage: ''));

    if (kDebugMode) {
      print('login_bloc -> _onGoogleSubmitted - > Entry');
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleCanceled {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: error.toString()));
      addError(error, stackTrace);
    }
  }

  /// [METHOD] Async login submission of Apple OAUTH
  /// Not used currently
  Future<void> _onAppleSubmitted(
    LoginAppleSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(errorMessage: ''));

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithApple();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, errorMessage: error.toString()));
      addError(error, stackTrace);
    }
  }

/*
  Future<void> _onTwitterSubmitted(
    LoginTwitterSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithTwitter();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithTwitterCanceled {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
 */

/*
  Future<void> _onFacebookSubmitted(
    LoginFacebookSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.logInWithFacebook();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithFacebookCanceled {
      emit(state.copyWith(status: FormzSubmissionStatus.canceled));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
 */
}
