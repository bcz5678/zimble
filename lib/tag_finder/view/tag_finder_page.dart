import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/tag_finder/tag_finder.dart';


class TagFinderPage extends StatelessWidget {
  const TagFinderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TagFinderBloc(),
      child: const TagFinderView(),
    );
  }
}