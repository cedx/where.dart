part of where;

/// Provides information about the status of a file system entity.
@visibleForTesting
class FileStat {

  /// Creates a new file status.
  const FileStat({this.uid = -1, this.gid = -1, this.mode = 0});

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
    if (platform.isWindows) throw new UnsupportedError('Not supported by the Windows platform.');

    var args = platform.isMacOS ? ['-f', '%u:%g:%p', '-L'] : ['--dereference', '--format=%u:%g:%a'];
    var result = await processManager.run(['stat']..addAll(args)..add(file));
    if (result.exitCode != 0) throw new ProcessException('stat', args);

    var parts = result.stdout.trim().split(':');
    if (parts.length != 3) throw new ProcessException('stat', args);

    return new FileStat(
      uid: int.parse(parts.first, radix: 10, onError: (_) => -1),
      gid: int.parse(parts[1], radix: 10, onError: (_) => -1),
      mode: int.parse(parts.last, radix: 8, onError: (_) => 0)
    );
  }

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'FileStat {uid: $uid, gid: $gid, mode: 0${mode.toRadixString(8)}}';
}
