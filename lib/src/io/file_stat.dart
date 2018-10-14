part of '../io.dart';

/// Represents the result of calling the POSIX [`stat`](http://manpages.ubuntu.com/manpages/xenial/man2/stat.2.html) function on a file system entity.
/// It is an immutable object, representing the snapshotted values returned by the `stat()` call.
class FileStat implements io.FileStat {

  /// Creates new file stats from the specified native [stats].
  factory FileStat._fromStats(io.FileStat stats, {int gid = -1, int uid = -1}) => FileStat._internal(stats.type,
    accessed: stats.accessed,
    changed: stats.changed,
    gid: gid,
    mode: stats.mode,
    modified: stats.modified,
    size: stats.size,
    uid: uid
  );

  /// Creates new file stats.
  FileStat._internal(this.type, {
    this.accessed,
    this.changed,
    this.gid = -1,
    this.mode = 0,
    this.modified,
    this.size = -1,
    this.uid = -1
  });

  /// Calls the operating system's `stat()` function on the specified [path].
  ///
  /// Completes with a [FileStat] object containing the data returned by `stat()`.
  /// If the call fails, completes the future with a [FileStat] object with [type] set to `FileSystemEntityType.notFound` and the other fields invalid.
  static Future<FileStat> stat(String path) async {
    var gid = -1;
    var uid = -1;

    if (!io.Platform.isWindows) {
      final args = io.Platform.isMacOS ? ['-f', '%u:%g', '-L'] : ['--dereference', '--format=%u:%g'];
      final result = await io.Process.run('stat', args..add(path));
      if (result.exitCode != 0) return FileStat._internal(io.FileSystemEntityType.notFound);

      final parts = result.stdout.trim().split(':');
      if (parts.length != 2) return FileStat._internal(io.FileSystemEntityType.notFound);

      uid = int.tryParse(parts.first, radix: 10) ?? -1;
      gid = int.tryParse(parts.last, radix: 10) ?? -1;
    }

    return FileStat._fromStats(await io.FileStat.stat(path), gid: gid, uid: uid);
  }

  /// Synchronously calls the operating system's `stat()` function on the specified [path].
  ///
  /// Returns a [FileStat] object containing the data returned by `stat()`.
  /// If the call fails, returns a [FileStat] object with [type] set to `FileSystemEntityType.notFound` and the other fields invalid.
  static FileStat statSync(String path) { // ignore: prefer_constructors_over_static_methods
    var gid = -1;
    var uid = -1;

    if (!io.Platform.isWindows) {
      final args = io.Platform.isMacOS ? ['-f', '%u:%g', '-L'] : ['--dereference', '--format=%u:%g'];
      final result = io.Process.runSync('stat', args..add(path));
      if (result.exitCode != 0) return FileStat._internal(io.FileSystemEntityType.notFound);

      final parts = result.stdout.trim().split(':');
      if (parts.length != 2) return FileStat._internal(io.FileSystemEntityType.notFound);

      uid = int.tryParse(parts.first, radix: 10) ?? -1;
      gid = int.tryParse(parts.last, radix: 10) ?? -1;
    }

    return FileStat._fromStats(io.FileStat.statSync(path), gid: gid, uid: uid);
  }

  /// The time of the last access to the data of the file system entity.
  /// On Windows platforms, this may have 1 day granularity, and be out of date by an hour.
  @override
  final DateTime accessed;

  /// The time of the last change to the data or metadata of the file system object.
  /// On Windows platforms, this is instead the file creation time.
  @override
  final DateTime changed;

  /// The numeric identity of the file's group.
  final int gid;

  /// The time of the last change to the data of the file system object.
  @override
  final DateTime modified;

  /// The mode of the file system entity. Permissions are encoded in the lower 16 bits of this number.
  @override
  final int mode;

  /// The total size, in bytes, of the file system entity.
  @override
  final int size;

  /// The type of the file system entity.
  /// If the call to `stat()` fails, the type of the returned entity is `FileSystemEntityType.notFound`.
  @override
  final io.FileSystemEntityType type;

  /// The numeric identity of the file's owner.
  final int uid;

  /// Returns the [mode] value as a human-readable string, in the format `"rwxrwxrwx"`,
  /// reflecting the user, group, and world permissions to read, write, and execute the file system entity,
  /// with `"-"` replacing the letter for missing permissions.
  ///
  /// Extra permission bits may be represented by prepending `"(suid)"`, `"(guid)"`, and/or `"(sticky)"` to the mode string.
  @override
  String modeString() {
    const codes = <String>['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'];
    final permissions = mode & 0xFFF;

    final result = <String>[];
    if ((permissions & 0x800) != 0) result.add('(suid) ');
    if ((permissions & 0x400) != 0) result.add('(guid) ');
    if ((permissions & 0x200) != 0) result.add('(sticky) ');

    result
      ..add(codes[(permissions >> 6) & 0x7])
      ..add(codes[(permissions >> 3) & 0x7])
      ..add(codes[permissions & 0x7]);

    return result.join();
  }

  /// Returns a string representation of this object.
  @override
  String toString() => 'FileStat("${modeString()}")';
}
