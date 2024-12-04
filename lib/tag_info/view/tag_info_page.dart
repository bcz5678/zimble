import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/tag_info/tag_info.dart';

class TagInfoPage extends StatelessWidget {
  const TagInfoPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TagInfoBloc(),
      child: const TagInfoView(),
    );
  }
}