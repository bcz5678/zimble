part of 'reader_repository.dart';


///[TODO]
///
///

/// Storage keys for the [ReaderStorage].
abstract class ReaderStorageKeys {
  ///
  //static const appOpenedCount = '__app_opened_count_key__';
}

/// {@template reader_storage}
/// Storage for the [ReaderRepository].
/// {@endtemplate}
class ReaderStorage {
  /// {@macro user_storage}
  const ReaderStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;
}
  /*
  /// Sets the number of times the app was opened.
  Future<void> setAppOpenedCount({required int count}) => _storage.write(
    key: ReaderStorageKeys.appOpenedCount,
    value: count.toString(),
  );

  /// Fetches the number of times the app was opened value from Storage.
  Future<int> fetchAppOpenedCount() async {
    final count = await _storage.read(key: ReaderStorageKeys.appOpenedCount);
    return int.parse(count ?? '0');
  }
}
   */
