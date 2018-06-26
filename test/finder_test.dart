import 'dart:io';
import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the `where` function.
void main() => group('Finder', () {
  var delimiter = Platform.isWindows ? ';' : ':';

  group('constructor', () {
    test('should set the `path` property to the value of the `PATH` environment variable by default', () {
      var pathEnv = Platform.environment['PATH'] ?? '';
      var path = pathEnv.isEmpty ? <String>[] : pathEnv.split(delimiter);
      expect(Finder().path, orderedEquals(path));
    });

    test('should split the input path using the path separator', () {
      var path = ['/usr/local/bin', '/usr/bin'];
      expect(Finder(path: path.join(delimiter)).path, orderedEquals(path));
    });

    test('should set the `extensions` property to the value of the `PATHEXT` environment variable by default', () {
      var pathExt = Platform.environment['PATHEXT'] ?? '';
      var extensions = pathExt.isEmpty ? <String>[] : pathExt.split(delimiter).map((item) => item.toLowerCase());
      expect(Finder().extensions, orderedEquals(extensions));
    });

    test('should split the extension list using the path separator', () {
      var extensions = ['.EXE', '.CMD', '.BAT'];
      expect(Finder(extensions: extensions.join(delimiter)).extensions, orderedEquals(['.exe', '.cmd', '.bat']));
    });

    test('should set the `pathSeparator` property to the value of the platform path separator by default', () {
      expect(Finder().pathSeparator, equals(delimiter));
    });

    test('should properly set the path separator', () {
      expect(Finder(pathSeparator: '#').pathSeparator, equals('#'));
    });
  });

  group('.find()', () {
    test('should return the path of the `executable.cmd` file on Windows', () async {
      var executables = await Finder(path: 'test/fixtures').find('executable').toList();
      expect(executables.length, equals(Platform.isWindows ? 1 : 0));
      if (Platform.isWindows) expect(executables.first, endsWith(r'\test\fixtures\executable.cmd'));
    });

    test('should return the path of the `executable.sh` file on POSIX', () async {
      var executables = await Finder(path: 'test/fixtures').find('executable.sh').toList();
      expect(executables.length, equals(Platform.isWindows ? 0 : 1));
      if (!Platform.isWindows) expect(executables.first, endsWith('/test/fixtures/executable.sh'));
    });
  });

  group('.isExecutable()', () {
    test('should return `false` for a non-executable file', () async {
      expect(await Finder().isExecutable('test/where_test.dart'), isFalse);
    });

    test('should return `false` for a POSIX executable, when test is run on Windows', () async {
      expect(await Finder().isExecutable('test/fixtures/executable.sh'), isNot(equals(Platform.isWindows)));
    });

    test('should return `false` for a Windows executable, when test is run on POSIX', () async {
      expect(await Finder().isExecutable('test/fixtures/executable.cmd'), equals(Platform.isWindows));
    });
  });
});