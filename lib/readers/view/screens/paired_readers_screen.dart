import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:permission_client/permission_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/readers/bloc/readers_bloc.dart';
import 'package:zimble/l10n/l10n.dart';
import 'package:zimble/readers/bloc/readers_connect/readers_connect_bluetooth_paired/readers_connect_bluetooth_paired_bloc.dart';

class PairedReadersScreen extends StatefulWidget {
  const PairedReadersScreen({super.key});

  @override
  State<PairedReadersScreen> createState() => _PairedReadersScreenState();
}

class _PairedReadersScreenState extends State<PairedReadersScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final ScrollController _btPairedController = ScrollController();
  final permissionClient = PermissionClient();

  @override
  void initState() {
    super.initState();

    getBTPermissions();

    context.read<ReadersConnectBluetoothPairedBloc>()
        .add(const GetPairedBluetoothDevices());

    if(kDebugMode) {
      print('paired_readers_screen -> didChangeDependencies - screen rebuilt');
    }
  }

  Future<void> getBTPermissions() async {

    var btScan = await permissionClient.requestBluetoothScan();
    var btConnect = await permissionClient.requestBluetoothConnect();

    if(kDebugMode) {
      print('paired_readers_screen -> didChangeDependencies - btscanstatus - $btScan');
      print('paired_readers_screen -> didChangeDependencies - btconnectstatus -  $btConnect');
    }
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: _btPairedController,
      slivers: [
        SliverToBoxAdapter(
          child: Column (
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: Text(
                          context.l10n.readersConnectTabPairedDevicesChooseReader,
                          textAlign: TextAlign.center,
                      ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.readersConnectTabPairedDevicesPreviouslyPaired),
                ],
              ),
            ],
          ),
        ),

        BlocBuilder<ReadersConnectBluetoothPairedBloc, ReadersConnectBluetoothPairedState>(
          builder: (context, state) {
            if (state.stateStatus ==
                ReadersConnectBluetoothPairedStatus.loading) {
              return SliverToBoxAdapter(
                child: CupertinoActivityIndicator(),
              );
            }
            if (state.stateStatus ==
                ReadersConnectBluetoothPairedStatus.done ||
                state.stateStatus == ReadersConnectBluetoothPairedStatus
                    .connectToDeviceStatusUpdate) {
              if (state.bluetoothPairedReaders != null) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return PairedReaderListItem(
                        reader: state.bluetoothPairedReaders![index],
                      );
                    },
                    childCount: state.bluetoothPairedReaders!.length,
                  ),
                );
              }
            }
            return SliverToBoxAdapter(
                child: SizedBox()
            );
          },
        ),
      ],
    );
  }
}

class PairedReaderListItem extends StatelessWidget {
  const PairedReaderListItem({
    required this.reader,
    super.key
  });

  final Reader reader;

  Reader? readerBluetoothInList(List<Reader> listOfReaders) {
    var readerToReturnList = listOfReaders.where(
            (reader) => reader.readerType == ReaderType.bluetooth);
    if (readerToReturnList.isNotEmpty){
      //Can only be one connected Bluetooth reader by device
      return readerToReturnList.first;
    } else {
      return null;
    }
  }

  Reader? readerMACAddressInList(Reader reader, List<Reader> listOfReaders) {
    var readerMatchToReturn = listOfReaders.where(
            (readerToCheck) => readerToCheck.macAddress == reader.macAddress);
    if(readerMatchToReturn.isNotEmpty) {
      return readerMatchToReturn.first;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentlyConnectedReadersList =
        context
          .read<ReaderRepository>()
          .currentlyAttachedReadersList.last as List<Reader>;

    final currentlyConnectedBluetoothReader =
      readerBluetoothInList(currentlyConnectedReadersList);



    return BlocBuilder<ReadersConnectBluetoothPairedBloc, ReadersConnectBluetoothPairedState>(
      builder: (context, state) {
        return ListTile(
          key: Key('pairedReaderListItem_${reader.macAddress}'),
          title: reader.name != 'null'
              ? Text(reader.name.toString())
              : const Text('(no name)'),
          subtitle: reader.macAddress != null
              ? Text('MAC: ${reader.macAddress}')
              : const Text(''),
          trailing: ElevatedButton(
            child: Builder(
              builder: (context) {
                if (state.stateStatus ==
                    ReadersConnectBluetoothPairedStatus
                      .connectToDeviceStatusLoading
                    && state.bluetoothDeviceToUpdate!.macAddress ==
                        reader.macAddress) {
                  /// Adds Circular Loading indicator to button that is pressed
                  /// while the device tries to connect
                  return const CupertinoActivityIndicator();

                } else if (state.stateStatus ==
                    ReadersConnectBluetoothPairedStatus
                        .connectToDeviceStatusUpdate
                    && readerMACAddressInList(
                        reader,
                        currentlyConnectedReadersList,
                    ) != null) {
                  /// State has a connection Status to update and the
                  /// current reader matches the device to update

                  if (currentlyConnectedBluetoothReader!.connectionStatus ?? true) {
                    /// ListItem reader is connected,
                    /// sets button text to disconnect
                    return const Text('Disconnect');
                  } else {
                    /// ListItem reader is not connected,
                    /// sets button text to connect
                    return const Text('Connect');
                  }
                } else {
                  return const Text('Connect');
                }
              }
            ),
            onPressed: () {
              if (currentlyConnectedBluetoothReader!.macAddress == reader.macAddress) {
                context
                    .read<ReadersConnectBluetoothPairedBloc>()
                    .add(
                    DisconnectFromBluetoothDevice(reader));
              } else {
                context
                    .read<ReadersConnectBluetoothPairedBloc>()
                    .add(ConnectToBluetoothDevice(reader));
              }
            },
          ),
        );
      }
    );
  }
}
