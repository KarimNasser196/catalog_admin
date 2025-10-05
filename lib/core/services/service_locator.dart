import 'package:catalog_admin/core/database/cache/cache_helper.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;
Future<void> setup() async {
  sl.registerLazySingleton<CacheHelper>(() => CacheHelper());
}
