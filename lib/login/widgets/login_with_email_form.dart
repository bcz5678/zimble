import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/l10n/l10n.dart';
import 'package:zimble/login/login.dart';
import 'package:form_inputs/form_inputs.dart';

class LoginWithEmailForm extends StatelessWidget {
  const LoginWithEmailForm({super.key});

  @override
  Widget build(BuildContext context) {
    final email = context.select((LoginBloc bloc) => bloc.state.email.value);
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xlg,
              AppSpacing.lg,
              AppSpacing.xlg,
              AppSpacing.xxlg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _HeaderLogo(),
                _HeaderTitle(),
                _HeaderSubtitle(),
                SizedBox(height: AppSpacing.xxxlg),
                _errorMessageBox(),
                _EmailInput(),
                _PasswordInput(),
                Align(
                  alignment: Alignment.centerRight,
                    child: _ForgotPasswordLink()
                ),
                _LoginButton(),
                SizedBox(height: AppSpacing.lg),
                Row(
                    children: [
                      Expanded(
                          child: Divider()
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.xlg,
                          0,
                          AppSpacing.xlg,
                          0,
                        ),
                          child: Text(
                              "or",
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: AppTheme().themeData.textTheme.bodyLarge?.fontSize,
                          )
                        ),
                      ),
                      Expanded(
                          child: Divider(),
                      ),
                    ]
                ),
                SizedBox(height: AppSpacing.lg),
                _GoogleLoginButton(),

              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.4,
        child: AppLogo.square(),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      context.l10n.loginWithEmailHeaderText,
      key: const Key('loginWithEmailForm_header_title'),
      style: theme.textTheme.displaySmall,
    );
  }
}

class _HeaderSubtitle extends StatelessWidget {
  const _HeaderSubtitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      context.l10n.loginWithEmailHeaderSubtitleText,
      key: const Key('loginWithEmailForm_header_subtitle'),
      style: theme.textTheme.bodyLarge,

    );
  }
}

class _errorMessageBox extends StatefulWidget {
  const _errorMessageBox({super.key});

  @override
  State<_errorMessageBox> createState() => _errorMessageBoxState();
}

class _errorMessageBoxState extends State<_errorMessageBox> {
  @override
  Widget build(BuildContext context) {
    final state = context
        .watch<LoginBloc>()
        .state;
    return Container(
      key: const Key('loginWithEmailForm_errorMessageBox'),
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: state.errorMessage != ''
            ? AppColors.redAlertBG
            : null,
      ),
      constraints: BoxConstraints(
          minHeight: AppSpacing.xxlg,
          minWidth: double.infinity,
      ),
      child: state.errorMessage != ''
          ? Text(
              context.l10n.authenticationFailure,
              style: TextStyle(
                color: AppColors.lingoWhite,
              )
            )
          : null,
    );
  }
}


class _PasswordInput extends StatefulWidget {
  const _PasswordInput();

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  final _controller = TextEditingController();
  late bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;

    return AppPasswordTextField(
      key: const Key('loginWithEmailForm_passwordInput_textField'),
      controller: _controller,
      readOnly: state.status.isInProgress,
      hintText: context.l10n.loginWithEmailPasswordTextFieldHint,
      obscureText: !_passwordVisible,
      onChanged: (password) =>
          context.read<LoginBloc>().add(LoginPasswordChanged(password)),
      suffix: IconButton(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          icon: Icon(
          _passwordVisible
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
          ),
        onPressed: () {
          // Update the state i.e. toogle the state of passwordVisible variable
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _EmailInput extends StatefulWidget {
  const _EmailInput();

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;

    return AppEmailTextField(
      key: const Key('loginWithEmailForm_emailInput_textField'),
      controller: _controller,
      readOnly: state.status.isInProgress,
      hintText: context.l10n.loginWithEmailEmailTextFieldHint,
      onChanged: (email) =>
          context.read<LoginBloc>().add(LoginEmailChanged(email)),
      suffix: ClearIconButton(
        onPressed: !state.status.isInProgress
            ? () {
          _controller.clear();
          context.read<LoginBloc>().add(const LoginEmailChanged(''));
        }
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xlg,
        0,
        0,
        AppSpacing.xlg,
      ),
      child: Text(
        context.l10n.loginWithEmailForgotPasswordText,
        key: const Key('loginWithEmailForm_forgotPasswordLink'),
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: theme.textTheme.bodyMedium?.fontSize,
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<LoginBloc>().state;

    return AppButton.lingoDark(
      key: const Key('loginWithEmailForm_loginButton'),
      onPressed: state.emailValid && state.passwordValid
          ? () => context.read<LoginBloc>().add(LoginEmailAndPasswordSubmitted())
          : null,
      child: state.status.isInProgress
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(),
            )
          : Text(l10n.loginButtonText),
    );
  }
}

@visibleForTesting
class ClearIconButton extends StatelessWidget {
  const ClearIconButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final suffixVisible =
        context.select((LoginBloc bloc) => bloc.state.email.value.isNotEmpty);

    return Padding(
      key: const Key('loginWithEmailForm_clearIconButton'),
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: Visibility(
        visible: suffixVisible,
        child: GestureDetector(
          onTap: onPressed,
          child: Assets.icons.closeCircle.svg(),
        ),
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  const _GoogleLoginButton();

  @override
  Widget build(BuildContext context) {
    return AppButton.outlinedWhite(
      key: const Key('loginWithEmailForm_googleLogin_appButton'),
      onPressed: () => context.read<LoginBloc>().add(LoginGoogleSubmitted()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.google.svg(),
          const SizedBox(width: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: Assets.images.continueWithGoogle.svg(),
          ),
        ],
      ),
    );
  }
}
