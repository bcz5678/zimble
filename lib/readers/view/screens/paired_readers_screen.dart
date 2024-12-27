import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:permission_client/permission_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_client/reader_client.dart';
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
      print('paired_readers_screen -> getBTPermissions - btscanstatus - $btScan');
      print('paired_readers_screen -> getBTPermissions - btconnectstatus -  $btConnect');
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
              if (state.bluetoothPairedDevices != null) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return PairedReaderListItem(
                        device: state.bluetoothPairedDevices![index],
                      );
                    },
                    childCount: state.bluetoothPairedDevices!.length,
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
    required this.device,
    super.key
  });

  final BluetoothDevice device;

  Reader? readerMACAddressInList(BluetoothDevice device, List<Reader> listOfReaders) {
    var readerMatchToReturn = listOfReaders.where(
            (readerToCheck) => readerToCheck.macAddress == device.macAddress);
    if(readerMatchToReturn.isNotEmpty) {
      return readerMatchToReturn.first;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadersConnectBluetoothPairedBloc, ReadersConnectBluetoothPairedState>(
      builder: (context, state) {
        return ListTile(
          key: Key('pairedReaderListItem_${device.macAddress}'),
          title: device.name != 'null'
              ? Text(device.name.toString())
              : const Text('(no name)'),
          subtitle: device.macAddress != null
              ? Text('MAC: ${device.macAddress}')
              : const Text(''),
          trailing: ElevatedButton(
            child: Builder(
              builder: (context) {
                if (state.stateStatus ==
                    ReadersConnectBluetoothPairedStatus
                      .connectToDeviceStatusLoading
                    && state.bluetoothDeviceToUpdate!.macAddress ==
                        device.macAddress) {
                  /// Adds Circular Loading indicator to button that is pressed
                  /// while the device tries to connect
                  return const CupertinoActivityIndicator();

                } else if (state.stateStatus ==
                    ReadersConnectBluetoothPairedStatus
                        .connectToDeviceStatusUpdate
                    && readerMACAddressInList(
                        device,
                        state.currentlyConnectedReadersList!,
                    ) != null) {
                  /// State has a connection Status to update and the
                  /// current reader matches the device to update
                    return const Text('Disconnect');
                } else {
                  return const Text('Connect');
                }
                return const Text('Test');
              },
            ),
            onPressed: () {
              if (readerMACAddressInList(
                        device,
                        state.currentlyConnectedReadersList!,
                    ) != null) {
                context
                    .read<ReadersConnectBluetoothPairedBloc>()
                    .add(
                    DisconnectFromBluetoothDevice(device));
              } else {
                context
                    .read<ReadersConnectBluetoothPairedBloc>()
                    .add(ConnectToBluetoothDevice(device));
              }
            },
          ),
        );
      }
    );
  }
}
