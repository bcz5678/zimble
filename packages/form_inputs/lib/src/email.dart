import 'package:formz/formz.dart';

/// Email Form Input Validation Error
enum EmailValidationError {
  /// Email is invalid (generic validation error)
  invalid
}

/// {@template email}
/// Reusable email form input.
/// {@endtemplate}
class Email extends FormzInput<String, EmailValidationError> {
  /// Sets Unmodified "pure" input at start
  const Email.pure() : super.pure('');

  /// Email.dirty changes as data input
  const Email.dirty([super.value = '']) : super.dirty();

  /// Email regex to match against
  static final RegExp _emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  /// Function: Email input Validator check
  /// Returns null if valid, and invalid if not allowed by regex
  @override
  EmailValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}
