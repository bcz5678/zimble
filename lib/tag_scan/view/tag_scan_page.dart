import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/tag_scan/tag_scan.dart';

class TagScanPage extends StatelessWidget {
  const TagScanPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TagScanBloc(
        readerRepository: context.read<ReaderRepository>(),
      ),
      child: const TagScanView(),
    );
  }
}