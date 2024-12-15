import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zimble/readers/bloc/readers_bloc.dart';
import 'package:zimble/l10n/l10n.dart';

class PairedReadersScreen extends StatefulWidget {
  const PairedReadersScreen({super.key});

  @override
  State<PairedReadersScreen> createState() => _PairedReadersScreenState();
}

class _PairedReadersScreenState extends State<PairedReadersScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  late ScrollController _btPairedController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ReadersBloc>().add(const GetPairedBluetoothDevices());
    context.read<ReadersBloc>().add(const GetCurrentReader());
    print("Paired_tab rebuilt");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Text(
                          context.l10n.readersConnectTabPairedDevicesChooseReader,
                          textAlign: TextAlign.center
                      )
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(context.l10n.readersConnectTabPairedDevicesPreviouslyPaired),
                ],
              ),

              BlocBuilder<ReaderConnectPairedBloc, ReaderConnectPairedState>(
                  builder: (context, state) {
                    if (state.stateStatus == ReaderConnectPairedStatus.pairedBluetoothDevicesInitial) {
                      return Center(
                          child: Text(context.l10n.readersConnectTabPairedDevicesSavedOrPaired));
                    }

                    if (state.stateStatus == ReaderConnectPairedStatus.pairedBluetoothDevicesLoading) {
                      return const Center(
                          child: CupertinoActivityIndicator()
                      );
                    }

                    if (state.stateStatus == ReaderConnectPairedStatus.pairedBluetoothDevicesDone ||
                        state.stateStatus == ReaderConnectPairedStatus.connectToDeviceStatusLoading ||
                        state.stateStatus == ReaderConnectPairedStatus.connectToDeviceStatusUpdate
                    ) {
                      if (state.pairedBluetoothDevices != null) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          controller: _btPairedController,
                          shrinkWrap: true,
                          itemCount: state.pairedBluetoothDevices !=
                              null
                              ? state.pairedBluetoothDevices?.length
                              : 0,
                          itemBuilder: (BuildContext context,
                              int index) {
                            return ListTile(
                              shape: Border(
                                top: BorderSide(color: Colors.grey, width: 1),

                              ),
                              title: state.pairedBluetoothDevices?[index].name != "null"
                                  ? Text("${state.pairedBluetoothDevices?[index].name}")
                                  : const Text('(no name)'),
                              subtitle: state.pairedBluetoothDevices?[index].MACaddress != null
                                  ? Text("MAC: ${state.pairedBluetoothDevices?[index].MACaddress} - ${state.pairedBluetoothDevices?[index].runtimeType}")
                                  : const Text(''),
                              trailing: ElevatedButton(
                                child: Builder(
                                    builder: (context) {
                                      if (state.stateStatus == ReaderConnectPairedStatus.connectToDeviceStatusLoading
                                          && state.bluetoothDeviceToUpdate!.MACaddress == state.pairedBluetoothDevices?[index].MACaddress) {
                                        return const CupertinoActivityIndicator();
                                      } else if (state.stateStatus == ReaderConnectPairedStatus.connectToDeviceStatusUpdate
                                          && state.currentlyConnectedReader!.MACaddress == state.pairedBluetoothDevices?[index].MACaddress) {
                                        if(state.currentlyConnectedReader!.connectionStatus == "isConnected") {
                                          return const Text('Disconnect');
                                        } else {
                                          return const Text('Connect');
                                        }
                                      } else {
                                        return const Text('Connect');
                                      }
                                    }
                                ),
                                onPressed: () {
                                  if (state.currentlyConnectedReader!.MACaddress == state.pairedBluetoothDevices?[index].MACaddress) {
                                    context
                                        .read<ReaderConnectPairedBloc>()
                                        .add(
                                        DisconnectFromBluetoothDevice(state.pairedBluetoothDevices![index]));
                                  } else {
                                    context
                                        .read<ReaderConnectPairedBloc>()
                                        .add(ConnectToBluetoothDevice(state.pairedBluetoothDevices![index]));
                                  }
                                },
                              ),
                            );
                            /*return DeviceListTilePaired(
                              bluetoothDeviceDetails: state.pairedBluetoothDevices?[index],
                          );
                          */
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    } else {
                      return const SizedBox();
                    }
                  }
              ),
            ],
          ),
        );
      }
    );
  }
}
