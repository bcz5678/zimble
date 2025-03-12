import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/tag_scan/tag_scan.dart';

class TagScanPage extends StatelessWidget {
  const TagScanPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    late ReaderRepository _readerRepository = context.read<ReaderRepository>();

    return BlocProvider(
      create: (_) => TagScanBloc(
        readerRepository: _readerRepository,
      ),
      child: const TagScanView(),
    );
  }
}