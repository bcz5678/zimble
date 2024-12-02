import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zimble/login/login.dart';
import 'package:user_repository/user_repository.dart';

class LoginWithEmailPage extends StatelessWidget {
  const LoginWithEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: AppBackButton(
            key: const Key("loginWithEmailPage_BackButton"),
            onPressed: () => context.pop(),
          ),
          backgroundColor: AppTheme().themeData.appBarTheme.backgroundColor,
          actions: [
            IconButton(
              key: const Key('loginWithEmailPage_closeIcon'),
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ],
        ),
        body: const LoginWithEmailForm(),
      ),
    );
  }
}
