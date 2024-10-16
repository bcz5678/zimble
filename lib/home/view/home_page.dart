import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/home/home.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Variable to return HomePage to AutoGeneratedRoutes
  // Separate Bloc Logic from UI
  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => HomeCubit()),
        ],
        child: const HomeView(),
    );
  }
}