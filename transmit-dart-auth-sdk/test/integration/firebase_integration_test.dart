import 'dart:convert';
import 'dart:io';

import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('firebase integration fixtures', () {
    test('bundled service-account fixture remains parseable', () async {
      final fixture = File('test/test.json');

      expect(fixture.existsSync(), isTrue);

      final jsonMap =
          jsonDecode(await fixture.readAsString()) as Map<String, dynamic>;

      expect(jsonMap['type'], equals('service_account'));
      expect(jsonMap['project_id'], isNotEmpty);
      expect(jsonMap['private_key'], contains('BEGIN PRIVATE KEY'));
      expect(jsonMap['client_email'], contains('@'));
    });
  });
}
