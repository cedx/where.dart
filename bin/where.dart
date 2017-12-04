#!/usr/bin/env dart

import 'dart:async';
import 'dart:isolate';
import 'package:args/args.dart';
import 'package:where/where.dart';
import 'package:yaml/yaml.dart';

/// The command line argument parser.
final ArgParser _parser = new ArgParser()
  ..addFlag('all', abbr: 'a', help: 'list all instances of executables found (instead of just the first one)', negatable: false)
  ..addFlag('silent', abbr: 's', help: 'silence the output, just return the exit code (0 if any executable is found, otherwise 1)', negatable: false)
  ..addFlag('help', abbr: 'h', help: 'output usage information', negatable: false)
  ..addFlag('version', abbr: 'v', help: 'output the version number', negatable: false);

/// The usage information.
final String usage = (new StringBuffer()
  ..writeln('Find the instances of an executable in the system path.')
  ..writeln()
  ..writeln('Usage:')
  ..writeln('pub global run where [options] <command>')
  ..writeln()
  ..writeln('Options:')
  ..write(_parser.usage))
  .toString();

/// The version number of this package.
Future<String> get version async {
  var uri = (await Isolate.resolvePackageUri(Uri.parse('package:where/'))).resolve('../pubspec.yaml');
  var pubspec = loadYaml(await fileSystem.file(uri.toFilePath(windows: platform.isWindows)).readAsString());
  return pubspec['version'];
}

/// Application entry point.
Future main(List<String> args) async {
  // Parse the command line arguments.
  ArgResults results;

  try {
    results = _parser.parse(const bool.fromEnvironment('node') ? arguments : args);
    if (results['help']) {
      print(usage);
      exit(0);
    }

    if (results['version']) {
      print(await version);
      exit(0);
    }

    if (results.rest.isEmpty) throw new ArgParserException('A command must be provided.');
  }

  on ArgParserException {
    print(usage);
    exit(64);
  }

  // Run the program.
  try {
    var executables = await where(results.rest.first, all: results['all'], onError: (_) => exit(1));
    if (!results['silent']) {
      if (executables is! List<String>) executables = [executables];
      executables.forEach(print);
    }

    exit(0);
  }

  on Exception catch (err) {
    print(err);
    exit(2);
  }
}
