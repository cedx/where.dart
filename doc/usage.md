path: blob/master/lib
source: src/file/where.dart

# Usage

## Find the instances of an executable
This package provides a single function, `where()`, allowing to locate a command in the system path:

```dart
import 'dart:async';
import 'package:where/where.dart';

Future<Null> main() async {
  try {
    // `path` is the absolute path to the executable.
    var path = await where('foobar');
    print('The command "foobar" is located at: $path');
  }

  on FinderException catch (err) {
    print('The command "${err.command}" is not found');
  }
}
```

The function returns a [`Future<String>`](https://api.dartlang.org/stable/dart-async/Future-class.html) that completes with the absolute path of the first instance of the executables found. If the command could not be located, the future completes with a `FinderException`.

## Options
The behavior of the `where()` function can be customized using the following optional named parameters.

### bool **all**
A value indicating whether to return all executables found, instead of just the first one.

If you pass `true` as parameter value, the function will return a `Future<List<String>>` providing all paths found, instead of a `Future<String>`:

```dart
import 'dart:async';
import 'package:where/where.dart';

Future<Null> main() async {
  var paths = await where('foobar', all: true);
  print('The command "foobar" was found at these locations:');
  for (var path in paths) print(path);
}
```

### String | List&lt;String&gt; **extensions**
The executable file extensions, provided as a string or a list of file extensions. Defaults to the list of extensions provided by the `PATHEXT` environment variable.

```dart
where('foobar', extensions: '.FOO;.EXE;.CMD');
where('foobar', extensions: ['.foo', '.exe', '.cmd']);
```

!!! tip
    The `extensions` option is only meaningful on the Windows platform,
    where the executability of a file is determined from its extension:

### dynamic **onError**(String command)
By default, when the specified command cannot be located, a `FinderException` is thrown. You can disable this exception by providing your own error handler:

```dart
import 'dart:async';
import 'package:where/where.dart';

Future<Null> main() async {
  var path = await where('foobar', onError: (command) => '');
  if (path.isEmpty) print('The command "foobar" was not found');
  else print('The command "foobar" is located at: $path');
}
```

When an `onError` handler is provided, it is called with the command as argument, and its return value is used instead. This is preferable to throwing and then immediately catching the `FinderException`.

### String | List&lt;String&gt; **path**
The system path, provided as a string or a list of directories. Defaults to the list of paths provided by the `PATH` environment variable.

```dart
where('foobar', path: '/usr/local/bin:/usr/bin');
where('foobar', path: ['/usr/local/bin', '/usr/bin']);
```

### String **pathSeparator**
The character used to separate paths in the system path. Defaults to the platform path separator (i.e. `";"` on Windows, `":"` on other platforms).

```dart
where('foobar', pathSeparator: '#');
// For example: "/usr/local/bin#/usr/bin"
```

## Command line interface
From a command prompt, install the `where` executable:

```shell
pub global activate where
```

!!! tip
    Consider adding the [`pub global`](https://www.dartlang.org/tools/pub/cmd/pub-global) executables directory to your system path.

Then use it to find the instances of an executable command:

```shell
where --help

Find the instances of an executable in the system path.

Usage:
where [options] <command>

Options:
-a, --all        list all instances of executables found (instead of just the first one)
-s, --silent     silence the output, just return the exit code (0 if any executable is found, otherwise 1)
-h, --help       output usage information
-v, --version    output the version number
```

For example:

```shell
where --all dart
```

### Node.js support
This package supports the [Node.js](https://nodejs.org) platform.
A JavaScript executable can be generated using the following [Grinder](http://google.github.io/grinder.dart) command:

```shell
pub run grinder
```

This command will build a `where.js` file in the `bin` folder of this package.
The generated executable has the same features as the [Dart](https://www.dartlang.org) command line:

```shell
node bin/where.js --help
node bin/where.js --all dart
```

!!! info
    Node.js support is provided through the [`nodejs_interop`](https://pub.dartlang.org/packages/nodejs_interop) library.