import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_client/permission_client.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/l10n/l10n.dart';
import 'package:zimble/readers/readers.dart';

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
    context.read<ReadersConnectBloc>()
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

        BlocBuilder<ReadersConnectBloc, ReadersConnectState>(
          builder: (context, state) {
            if (state.stateStatus == ReadersConnectStatus.pairedLoading) {
              return SliverToBoxAdapter(
                child: CupertinoActivityIndicator(),
              );
            }
            if ([ReadersConnectStatus.pairedDone,
                ReadersConnectStatus.pairedBluetoothDevicesUpdated,
                ReadersConnectStatus.connectToDeviceStatusInProgress,
                ReadersConnectStatus.connectToDeviceStatusUpdate]
                  .contains(state.stateStatus)
            ) {
              if (state.bluetoothPairedDevicesList != null) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return ConnectDeviceListItem(
                        device: state.bluetoothPairedDevicesList![index],
                      );
                    },
                    childCount: state.bluetoothPairedDevicesList!.length,
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
