import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reader_client/reader_client.dart';
import 'package:reader_repository/reader_repository.dart';
import 'package:zimble/l10n/l10n.dart';


import 'package:zimble/readers/readers.dart';


class ConnectDeviceListItem extends StatelessWidget {
  ConnectDeviceListItem({
    required this.device,
    super.key
  });

  final BluetoothDevice device;
  late bool isDeviceCurrentlyAttached;

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
    return BlocBuilder<ReadersConnectBloc, ReadersConnectState>(
      builder: (context, state) {

        var currentlyAttachedReadersList = context.select((ReadersBloc bloc) => bloc.state.currentlyAttachedReadersList!);

        isDeviceCurrentlyAttached = isDeviceMACAddressInReaderList(
            device,
            currentlyAttachedReadersList
        );

        return ListTile(
          key: Key('connectDeviceListItem_${device.macAddress}'),
          title: device.name != 'null'
              ? Text(device.name.toString())
              : Text(context.l10n.readersConnectTabUnnamedDevice),
          subtitle: device.macAddress != null
              ? Text('MAC: ${device.macAddress}')
              : Text(''),
          trailing: ElevatedButton(
            child: Builder(
              builder: (context) {
                if (state.stateStatus == ReadersConnectStatus.connectionStatusInProgress
                    && state.selectedBluetoothDevice!.macAddress == device.macAddress
                ) {
                  /// Adds Circular Loading indicator to button that is pressed
                  /// while the device tries to connect
                  return const CupertinoActivityIndicator();

                } else if (state.stateStatus == ReadersConnectStatus.connectionStatusSuccess
                    && isDeviceCurrentlyAttached
                ) {
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
              if (isDeviceCurrentlyAttached) {
                if(kDebugMode) {
                  print('connect_readers_screen -> onPressed -> disconnect');

                }
                context
                    .read<ReadersConnectBloc>()
                    .add(
                    DisconnectFromBluetoothDevice(device));
              } else {

                if(kDebugMode) {
                  print('paired_readers_screen -> onPressed -> connect');

                }
                context
                    .read<ReadersConnectBloc>()
                    .add(ConnectToBluetoothDevice(device));
              }
            },
          ),
        );
      }
    );
  }
}
