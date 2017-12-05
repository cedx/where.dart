import 'dart:async';
import 'package:nodejs_interop/nodejs_interop.dart';

/// The command line arguments.
List<String> get arguments => process.argv.skip(2).toList();

/// The global exit code for the process.
int get exitCode => process.exitCode;
set exitCode(int value) => process.exitCode = value;

/// A reference to the file system.
const FileSystem fileSystem = const FileSystem();

/// A reference to the platform.
const Platform platform = const Platform();

/// A reference to the process manager.
const ProcessManager processManager = const ProcessManager();

/// The numeric group identity of the process.
Future<int> get processGid => new Future.value(platform.isWindows ? -1 : process.getgid());

/// The numeric user identity of the process.
Future<int> get processUid => new Future.value(platform.isWindows ? -1 : process.getuid());
