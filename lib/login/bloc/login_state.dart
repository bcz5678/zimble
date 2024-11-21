part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.emailValid = false,
    this.passwordValid = false,
    this.errorMessage = '',
  });

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;
  final bool emailValid;
  final bool passwordValid;
  final String errorMessage;

  @override
  List<Object> get props => [
    email,
    password,
    status,
    emailValid,
    passwordValid,
    errorMessage
  ];

  LoginState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
    bool? emailValid,
    bool? passwordValid,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      emailValid: emailValid ?? this.emailValid,
      passwordValid: passwordValid ?? this.passwordValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
