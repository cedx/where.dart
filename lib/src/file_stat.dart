part of where;

/// Provides information about the status of a file system entity.
@visibleForTesting
class FileStat {

  /// Creates a new file status.
  FileStat([this.uid = -1, this.gid = -1, this.mode = 0]);

  /// The numeric identity of the file's group.
  final int gid;

  /// The file permissions.
  final int mode;

  /// The numeric identity of the file's owner.
  final int uid;

  /// Returns the status of the specified [file].
  ///
  /// Throws a [ProcessException] if an error occurred while running the underlying `stat` process.
  /// Always throws an [UnsupportedError] on the Windows platform.
  static Future<FileStat> stat(String file) async {
    if (Platform.isWindows) throw new UnsupportedError('Not supported on the Windows platform.');

    var args = Platform.isMacOS ? ['-f', '%g:%u:%p', '-L'] : ['--dereference', '--format=%u:%g:%a'];
    var result = await Process.run('stat', args..add(file));
    if (result.exitCode != 0) throw new ProcessException('stat', args);

    var parts = result.stdout.trim().split(':');
    if (parts.length != 3) throw new ProcessException('stat', args);

    return new FileStat(
      int.parse(parts.first, radix: 10, onError: (_) => -1),
      int.parse(parts[1], radix: 10, onError: (_) => -1),
      int.parse(parts.last, radix: 8, onError: (_) => 0)
    );
  }

  /// Returns a string representation of this object.
  @override
  String toString() => '$runtimeType {uid: $uid, gid: $gid, mode: 0${mode.toRadixString(8)}}';
}
