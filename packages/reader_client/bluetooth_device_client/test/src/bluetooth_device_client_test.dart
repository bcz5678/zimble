// ignore_for_file: prefer_const_constructors

import 'package:bluetooth_device_client/bluetooth_device_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BluetoothDeviceClient', () {
    test('can be instantiated', () {
      expect(BluetoothDeviceClient(), isNotNull);
    });
  });
}
