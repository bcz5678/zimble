import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/dash/dash.dart';


class DashPage extends StatelessWidget {
  const DashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DashBloc()),
      ],
      child: const DashView(),
    );
  }
}