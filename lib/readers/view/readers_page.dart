import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/readers/readers.dart';


class ReadersPage extends StatelessWidget {
  const ReadersPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReadersBloc(
          readerRepository: context.read<ReaderRepository>()
      ),
      child: const ReadersView(),
    );
  }
}