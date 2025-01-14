import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_client/permission_client.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/l10n/l10n.dart';
import 'package:zimble/readers/readers.dart';

class ScanReadersScreen extends StatefulWidget {
  const ScanReadersScreen({super.key});

  @override
  State<ScanReadersScreen> createState() => _ScanReadersScreenState();
}

class _ScanReadersScreenState extends State<ScanReadersScreen>  with AutomaticKeepAliveClientMixin  {

  @override
  bool get wantKeepAlive => true;

  late bool  _btScanningState = false;
  late ScrollController _btScanController = ScrollController();
  final permissionClient = PermissionClient();

  @override
  void initState() {
    super.initState();
    getBTPermissions();

  }

  Future<void> getBTPermissions() async {
    //[TODO] flesh out permissions handling
    var btScanPermissions = await permissionClient.requestBluetoothScan();
    var btConnectPermissions = await permissionClient.requestBluetoothConnect();
    var locationPermissions = await permissionClient.requestLocation();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: _btScanController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_btScanningState == false) {
                        context
                            .read<ReadersConnectBluetoothScannedBloc>()
                            .add(StartScanningBluetoothDevices());
                        setState(() {
                          _btScanningState = !_btScanningState;
                        });
                      } else {
                        context
                            .read<ReadersConnectBluetoothScannedBloc>()
                            .add(StopScanningBluetoothDevices());
                        setState(() {
                          _btScanningState = !_btScanningState;
                        });
                      }
                    },
                    child: _btScanningState == false
                        ? Text(context.l10n.readersConnectTabScanButtonStart)
                        : Text(context.l10n.readersConnectTabScanButtonStop),
                  ),
                ],
              ),
            ],
          ),

        ),
        BlocBuilder<ReadersConnectBluetoothScannedBloc, ReadersConnectBluetoothScannedState>(
          builder: (context, state) {
            if (state.stateStatus == ReadersConnectBluetoothScannedStatus.loading) {
              return SliverToBoxAdapter(
                  child: CupertinoActivityIndicator()
              );
            } else
            if (state.stateStatus == ReadersConnectBluetoothScannedStatus.scannedBluetoothDevicesUpdated) {
              if (state.bluetoothScannedDevicesList!.isNotEmpty) {
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return ScannedDeviceListItem(
                          device: state.bluetoothScannedDevicesList![index]
                      );
                    },
                      childCount: state.bluetoothScannedDevicesList!.length,
                  )
                );
              }
            }
            return SliverToBoxAdapter(
              child: SizedBox(),
            );
          },
        ),
      ],
    );
  }
}

class ScannedDeviceListItem extends StatelessWidget {
  ScannedDeviceListItem({
    required this.device,
    super.key
  });

  final BluetoothDevice device;
  late bool isDeviceCurrentlyConnected;

  bool isDeviceMACAddressInReaderList(BluetoothDevice device, List<Reader> listOfReaders) {
    var readerMatchToReturn = listOfReaders.where(
            (readerToCheck) => readerToCheck.macAddress == device.macAddress);
    if(readerMatchToReturn.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ReadersConnectBluetoothScannedBloc, ReadersConnectBluetoothScannedState>(
      builder: (context, state) {

        isDeviceCurrentlyConnected = isDeviceMACAddressInReaderList(
            device,
            context.select((ReadersBloc bloc) => bloc.state.currentlyConnectedReadersList ?? []
            )
        );

        return ListTile(
          key: Key('scannedDeviceListItem_${device.macAddress}'),
          title: device.name != 'null'
            ? Text(device.name.toString())
            : Text(context.l10n.readersConnectTabUnnamedDevice),
          subtitle: device.macAddress != null
            ? Text('MAC: ${device.macAddress}')
            : Text(''),
          trailing: ElevatedButton(
            child: Builder(
              builder: (context) {
                if (state.stateStatus ==
                  ReadersConnectBluetoothScannedStatus
                    .connectToDeviceStatusLoading
                  && state.selectedBluetoothDevice!.macAddress ==
                  device.macAddress) {
                    /// Adds Circular Loading indicator to button that is pressed
                    /// while the device tries to connect
                    return const CupertinoActivityIndicator();

                  } else if (state.stateStatus ==
                    ReadersConnectBluetoothPairedStatus.connectToDeviceStatusUpdate
                    && isDeviceCurrentlyConnected) {
                    /// State has a connection Status to update and the
                    /// current reader matches the device to update
                    return Text(context.l10n.readersConnectTabButtonDisconnect);
                  } else {
                    return Text(context.l10n.readersConnectTabButtonConnect);
                  }
                  return Text(context.l10n.readersConnectTabButtonConnect);
                },
              ),
              onPressed: () {
                if (isDeviceCurrentlyConnected) {
                  if(kDebugMode) {
                    print('scanned_readers_screen -> onPressed -> disconnect');

                  }
                context
                    .read<ReadersConnectBluetoothPairedBloc>()
                    .add(DisconnectFromBluetoothDevice(device));
                } else {

                  if(kDebugMode) {
                    print('scanned_readers_screen -> onPressed -> connect');

                  }
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
