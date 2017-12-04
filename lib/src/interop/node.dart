import 'package:nodejs_interop/nodejs_interop.dart';

/// The command line arguments.
List<String> get arguments => process.argv.skip(2).toList();

/// A reference to the file system.
const FileSystem fileSystem = const FileSystem();

/// A reference to the platform.
const Platform platform = const Platform();

/// A reference to the process manager.
const ProcessManager processManager = const ProcessManager();

/// Exits the process immediately with the given exit [code].
void exit([int code = 0]) => process.exit(code);
