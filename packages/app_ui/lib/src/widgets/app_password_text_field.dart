import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_email_text_field}
/// An email text field component.
/// {@endtemplate}
class AppPasswordTextField extends StatelessWidget {
  /// {@macro app_email_text_field}
  const AppPasswordTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suffix,
    this.readOnly,
    this.onChanged,
    this.obscureText = true,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;


  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool? readOnly;

  ///Boolean to hide/show text for passworfield
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.emailAddress,
      autoFillHints: const [AutofillHints.email],
      autocorrect: false,
      obscureText: obscureText,
      prefix: const Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
        ),
        child: Icon(
          Icons.lock_outline,
          color: AppColors.mediumEmphasisSurface,
          size: 24,
        ),
      ),
      readOnly: readOnly ?? false,
      onChanged: onChanged,
      suffix: suffix,
    );
  }
}
