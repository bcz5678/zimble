// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:usb_reader_client/usb_reader_client.dart';

void main() {
  group('UsbReaderClient', () {
    test('can be instantiated', () {
      expect(UsbReaderClient(), isNotNull);
    });
  });
}
