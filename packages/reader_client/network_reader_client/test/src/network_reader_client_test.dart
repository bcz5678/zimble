// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:network_reader_client/network_reader_client.dart';

void main() {
  group('NetworkReaderClient', () {
    test('can be instantiated', () {
      expect(NetworkReaderClient(), isNotNull);
    });
  });
}