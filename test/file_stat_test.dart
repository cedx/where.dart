import 'dart:io' hide FileStat;
import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the `FileStat` class.
void main() => group('FileStat', () {
  group('.modeString()', () {
    test('should return the file mode as a human-readable string', () async {
      final mode = (await FileStat.stat('test/file_stat_test.dart')).modeString();
      expect(mode, matches(RegExp(r'([r\-][w\-][x\-]){3}$')));
    });
  });

  group('.stat()', () {
    test('should return a `FileSystemEntityType.notFound` if the file does not exist', () async {
      final fileStats = await FileStat.stat('foo/bar/baz.dart');
      expect(fileStats.modeString(), equals('---------'));
      expect(fileStats.type, equals(FileSystemEntityType.notFound));
    });

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
    test('should return a `FileSystemEntityType.notFound` if the file does not exist', () {
      final fileStats = FileStat.statSync('foo/bar/baz.dart');
      expect(fileStats.modeString(), equals('---------'));
      expect(fileStats.type, equals(FileSystemEntityType.notFound));
    });

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
