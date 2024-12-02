import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zimble/error/error.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({
    required this.error,
    super.key
  });

  final GoException? error;

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ErrorBloc(widget.error),
      child: Scaffold(
        appBar: AppBar(
          leading: AppBackButton(
            key: const Key("errorPage_BackButton"),
            onPressed: () => context.pop(),
          ),
          backgroundColor: AppTheme().themeData.appBarTheme.backgroundColor,
          actions: [
            IconButton(
              key: const Key('errorPage_closeIcon'),
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
          ],
        ),
        body: const ErrorView(),
      ),
    );
  }
}