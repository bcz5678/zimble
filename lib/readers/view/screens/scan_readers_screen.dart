import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_client/permission_client.dart';
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
    //[TODO] flesh out permissions handling Zimble, zimble, libmain
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
                            .read<ReadersConnectBloc>()
                            .add(StartScanningBluetoothDevices());
                        setState(() {
                          _btScanningState = !_btScanningState;
                        });
                      } else {
                        context
                            .read<ReadersConnectBloc>()
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
        BlocBuilder<ReadersConnectBloc, ReadersConnectState>(
          builder: (context, state) {
            if (state.stateStatus == ReadersConnectStatus.scannedLoading) {
              return SliverToBoxAdapter(
                  child: CupertinoActivityIndicator()
              );
            } else
            if ([ ReadersConnectStatus.scannedDone,
                  ReadersConnectStatus.scannedBluetoothDevicesUpdated,
                  ReadersConnectStatus.connectionStatusInProgress,
                  ReadersConnectStatus.connectionStatusSuccess,
                  ReadersConnectStatus.connectionStatusFailed,
                ].contains(state.stateStatus)) {
              if (state.bluetoothScannedDevicesList!.isNotEmpty) {
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return ConnectDeviceListItem(
                          device: state.bluetoothScannedDevicesList![index]
                      );
                    },
                      childCount: state.bluetoothScannedDevicesList!.length,
                  )
                );
              } else {
                return SliverToBoxAdapter(
                  child: SizedBox(),
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
