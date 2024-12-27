// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:usb_device_client/usb_device_client.dart';

void main() {
  group('UsbDeviceClient', () {
    test('can be instantiated', () {
      expect(UsbDeviceClient(), isNotNull);
    });
  });
}
