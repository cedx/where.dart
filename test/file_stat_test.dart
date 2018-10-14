import 'dart:io' hide FileStat;
import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the `FileStat` class.
void main() => group('FileStat', () {
  group('.modeString()', () async {
    final data = (await FileStat.stat('test/file_stat_test.dart')).modeString();
    expect(data, contains('FileStat('));
  });

  group('.stat()', () {
    test('should return a numeric identity greater than or equal to 0 for the file owner', () async {
      final fileStats = await FileStat.stat('test/file_stat_test.dart');
      expect(fileStats.uid, Platform.isWindows ? equals(-1) : greaterThanOrEqualTo(0));
    });

    test('should return a numeric identity greater than or equal to 0 for the file group', () async {
      final fileStats = await FileStat.stat('test/file_stat_test.dart');
      expect(fileStats.gid, Platform.isWindows ? equals(-1) : greaterThanOrEqualTo(0));
    });
  });

  group('.statSync()', () {
    test('should return a numeric identity greater than or equal to 0 for the file owner', () {
      final fileStats = FileStat.statSync('test/file_stat_test.dart');
      expect(fileStats.uid, Platform.isWindows ? equals(-1) : greaterThanOrEqualTo(0));
    });

    test('should return a numeric identity greater than or equal to 0 for the file group', () {
      final fileStats = FileStat.statSync('test/file_stat_test.dart');
      expect(fileStats.gid, Platform.isWindows ? equals(-1) : greaterThanOrEqualTo(0));
    });
  });
});
