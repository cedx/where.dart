/// Find the instances of an executable in the system path.
library where;
// ignore_for_file: directives_ordering

import 'dart:async';
import 'dart:io' show ProcessException;
import 'package:file/file.dart';
import 'package:meta/meta.dart';

import 'interop.dart'
  if (dart.library.io) 'src/interop/vm.dart'
  if (node) 'src/interop/node.dart';

export 'interop.dart'
  if (dart.library.io) 'src/interop/vm.dart'
  if (node) 'src/interop/node.dart';

part 'src/file_stat.dart';
part 'src/finder.dart';
part 'src/where.dart';
