// ignore_for_file: prefer_const_constructors

import 'package:authentication_client/authentication_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationClient', () {
    test('can be instantiated', () {
      expect(AuthenticationClient(), isNotNull);
    });
  });
}
