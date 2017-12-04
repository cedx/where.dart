/// Provides interoperability with native APIs.
library where.interop;

import 'package:file/file.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';

/// The command line arguments.
List<String> get arguments => null;

/// A reference to the file system.
const FileSystem fileSystem = null;

/// A reference to the platform.
const Platform platform = null;

/// A reference to the process manager.
const ProcessManager processManager = null;

/// Exits the process immediately with the given exit [code].
void exit([int code = 0]) => null;
