import 'dart:io';

import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('sample app inventory', () {
    test('example README entries point at real directories', () async {
      final readme = File('example/README.md');

      expect(readme.existsSync(), isTrue);

      final lines = await readme.readAsLines();
      final sampleDirs = lines
          .map((line) => line.trim())
          .where((line) => line.startsWith('- `') && line.endsWith('`'))
          .map((line) => line.substring(3, line.length - 1))
          .toList();

      expect(sampleDirs, isNotEmpty);

      for (final sampleDir in sampleDirs) {
        expect(Directory('example/$sampleDir').existsSync(), isTrue);
      }
    });
  });
}
