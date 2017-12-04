import 'dart:io' as io;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';

/// The command line arguments.
List<String> get arguments => throw new UnsupportedError('Not supported by the Dart VM.');

/// A reference to the file system.
const FileSystem fileSystem = const LocalFileSystem();

/// A reference to the platform.
const Platform platform = const LocalPlatform();

/// A reference to the process manager.
const ProcessManager processManager = const LocalProcessManager();

/// Exits the process immediately with the given exit [code].
void exit([int code = 0]) => io.exit(code);
