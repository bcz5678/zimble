import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/trigger/trigger.dart';


class TriggerPage extends StatelessWidget {
  const TriggerPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TriggerBloc(),
      child: const TriggerView(),
    );
  }
}