import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/readers/readers.dart';

class AttachedReadersScreen extends StatefulWidget {
  const AttachedReadersScreen({super.key});

  @override
  State<AttachedReadersScreen> createState() => _AttachedReadersScreenState();
}


class _AttachedReadersScreenState extends State<AttachedReadersScreen>  with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  late ReaderRepository _readerRepository = context.read<ReaderRepository>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReadersAttachedBloc>(
      create: (context) =>
        ReadersAttachedBloc(
          readerRepository: _readerRepository,
        ),
      child: const AttachedReadersView(),
    );
  }
}

class AttachedReadersView extends StatefulWidget {
  const AttachedReadersView({super.key});

  @override
  State<AttachedReadersView> createState() => _AttachedReadersViewState();
}

class _AttachedReadersViewState extends State<AttachedReadersView> {

  @override
  Widget build(BuildContext context) {

    var currentlyAttachedReadersList = context.select((ReadersBloc bloc) => bloc.state.currentlyAttachedReadersList);


    return BlocBuilder<ReadersAttachedBloc, ReadersAttachedState>(
      builder: (context, state) {
        if (state.stateStatus == ReadersAttachedStatus.initial
            && currentlyAttachedReadersList != null
        && currentlyAttachedReadersList.isNotEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var reader in currentlyAttachedReadersList) ReaderDetails(reader: reader),
            ],
          );
        } else {
          return Text("nothing here");
        }
      },
    );
  }
}

class ReaderDetails extends StatelessWidget {
  ReaderDetails({
    required this.reader,
    super.key
  });

  final Reader reader;

  @override
  Widget build(BuildContext context) {
    print('attached_readers_screen - ReaderDetails - ${reader}');

    return Column(
      children: [
        Row(
          children: [
            const Text('Name: '),
            Text('${reader.name}'),
          ],
        ),
        Row(
          children: [
            const Text('Reader Type: '),
            Text('${reader.readerType}'),
          ],
        ),
        Row(
          children: [
            const Text('MAC Address: '),
            Text('${reader.macAddress}'),
          ],
        ),
        Row(
          children: [
            const Text('Serial Number: '),
            Text('${reader.serialNumber}'),
          ],
        ),
        Row(
          children: [
            const Text('Model Number: '),
            Text('${reader.readerDetails?.model}'),
          ],
        ),
        Row(
          children: [
            const Text('IP Address: '),
            Text('${reader.ipAddress}'),
          ],
        ),
        Row(
          children: [
            const Text('Image Stub: '),
            Text('${reader.imageStub}'),
          ],
        ),
        Row(
          children: [
            const Text('Maximum Carrier Power: '),
            Text('${reader.readerDetails?.maximumCarrierPower}'),
          ],
        ),
        Row(
          children: [
            const Text('Minimum Carrier Power: '),
            Text('${reader.readerDetails?.minimumCarrierPower}'),
          ],
        ),
        Row(
          children: [
            const Text('IsFastIdSupported: '),
            Text('${reader.readerDetails?.isFastIdSupported}'),
          ],
        ),
        Row(
          children: [
            const Text('IsQTModeSupported: '),
            Text('${reader.readerDetails?.isQTModeSupported}'),
          ],
        ),
        Row(
          children: [
            const Text('LinkProfile: '),
            Text('${reader.readerDetails?.linkProfile}'),
          ],
        ),
        Row(
          children: [
            const Text('Trigger Double Press Repeat Delay: '),
            Text('${reader.triggerSettings?.doublePressRepeatDelay}'),
          ],
        ),
        Row(
          children: [
            const Text('Trigger Single Press Repeat Delay: '),
            Text('${reader.triggerSettings?.singlePressRepeatDelay}'),
          ],
        ),
        Row(
          children: [
            const Text('Implements Read Parameters: '),
            Text('${reader.triggerSettings?.implementsReadParameters}'),
          ],
        ),
        Row(
          children: [
            const Text('Implements Reset Parameters: '),
            Text('${reader.triggerSettings?.implementsResetParameters}'),
          ],
        ),
        Row(
          children: [
            const Text('Implements taek No Action: '),
            Text('${reader.triggerSettings?.implementsTakeNoAction}'),
          ],
        ),
        Row(
          children: [
            const Text('Polling Enabled: '),
            Text('${reader.triggerSettings?.pollingReportingEnabled}'),
          ],
        ),
      ]
    );
  }
}
