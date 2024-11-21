import 'package:formz/formz.dart';

/// Password Form Input Validation Error
enum PasswordValidationError {
  /// Password is invalid (generic validation error)
  invalid
}

/// {@template email}
/// Reusable email form input.
/// {@endtemplate}
class Password extends FormzInput<String, PasswordValidationError> {
  /// Sets Unmodified "pure" input at start
  const Password.pure() : super.pure('');

  /// Password.dirty changes as data input
  const Password.dirty([super.value = '']) : super.dirty();

  /// Password regex to match against
  /// r'^
  ///   (?=.*[A-Z])       // should contain at least one upper case
  ///   (?=.*[a-z])       // should contain at least one lower case
  ///   (?=.*?[0-9])      // should contain at least one digit
  ///   (?=.*?[!@#\$&*~]) // should contain at least one Special character
  ///   .{8,}             // Must be at least 8 characters in length
  /// $'
  static final RegExp _passwordRegExp = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
  );

  /// Function: Password input Validator check
  /// Returns null if valid, and invalid if not allowed by regex
  @override
  PasswordValidationError? validator(String value) {
    return _passwordRegExp.hasMatch(value) ? null : PasswordValidationError.invalid;
  }
}
