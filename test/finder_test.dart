import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the [Finder] class.
void main() => group('Finder', () {
  var delimiter = Finder.isWindows ? ';' : ':';

  group('constructor', () {
    test('should set the `path` property to the value of the `PATH` environment variable by default', () {
      var pathEnv = platform.environment['PATH'] ?? '';
      var path = pathEnv.isEmpty ? [] : pathEnv.split(delimiter);
      expect(new Finder().path, orderedEquals(path));
    });

    test('should split the input path using the path separator', () {
      var path = ['/usr/local/bin', '/usr/bin'];
      expect(new Finder(path: path.join(delimiter)).path, orderedEquals(path));
    });

    test('should set the `extensions` property to the value of the `PATHEXT` environment variable by default', () {
      var pathExt = platform.environment['PATHEXT'] ?? '';
      var extensions = pathExt.isEmpty ? [] : pathExt.split(delimiter);
      expect(new Finder().extensions, orderedEquals(extensions));
    });

    test('should split the extension list using the path separator', () {
      var extensions = const ['.EXE', '.CMD', '.BAT'];
      expect(new Finder(extensions: extensions.join(delimiter)).extensions, orderedEquals(extensions));
    });

    test('should set the `pathSeparator` property to the value of the platform path separator by default', () {
      expect(new Finder().pathSeparator, equals(delimiter));
    });

    test('should properly set the path separator', () {
      expect(new Finder(pathSeparator: '#').pathSeparator, equals('#'));
    });
  });

  group('.find()', () {
    test('should return the path of the `executable.cmd` file on Windows', () async {
      var executables = await new Finder(path: 'test/fixtures').find('executable').toList();
      expect(executables.length, equals(Finder.isWindows ? 1 : 0));
      if (Finder.isWindows) expect(executables.first, endsWith(r'\test\fixtures\executable.cmd'));
    });

    test('should return the path of the `executable.sh` file on POSIX', () async {
      var executables = await new Finder(path: 'test/fixtures').find('executable.sh').toList();
      expect(executables.length, equals(Finder.isWindows ? 0 : 1));
      if (!Finder.isWindows) expect(executables.first, endsWith('/test/fixtures/executable.sh'));
    });
  });

  group('.isExecutable()', () {
    test('should return `false` for a non-executable file', () async {
      expect(await new Finder().isExecutable('test/finder_test.dart'), isFalse);
    });

    test('should return `false` for a POSIX executable, when test is run on Windows', () async {
      expect(await new Finder().isExecutable('test/fixtures/executable.sh'), isNot(equals(Finder.isWindows)));
    });

    test('should return `false` for a Windows executable, when test is run on POSIX', () async {
      expect(await new Finder().isExecutable('test/fixtures/executable.cmd'), equals(Finder.isWindows));
    });
  });
});
