import 'package:catalog_admin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:catalog_admin/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:catalog_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:catalog_admin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:catalog_admin/core/database/cache/cache_helper.dart';
import 'package:catalog_admin/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:catalog_admin/features/dashboard/data/repositories/ashboard_repository_impl.dart';
import 'package:catalog_admin/features/dashboard/domain/repositories/ashboard_repository.dart';
import 'package:catalog_admin/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:catalog_admin/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:catalog_admin/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:catalog_admin/features/payment/domain/repositories/payment_repository.dart';
import 'package:catalog_admin/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:catalog_admin/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:catalog_admin/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:catalog_admin/features/profile/domain/repositories/profile_repository.dart';
import 'package:catalog_admin/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:catalog_admin/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:catalog_admin/features/promo/data/repositories/romo_repository_impl.dart';
import 'package:catalog_admin/features/promo/domain/repositories/promo_repository.dart';
import 'package:catalog_admin/features/promo/presentation/cubit/promo_cubit.dart';
import 'package:catalog_admin/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:catalog_admin/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:catalog_admin/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:catalog_admin/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:catalog_admin/features/transactions/data/datasources/transactionremote_datasource.dart';
import 'package:catalog_admin/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:catalog_admin/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:catalog_admin/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:catalog_admin/features/users/data/datasources/user_remote_datasource.dart';
import 'package:catalog_admin/features/users/data/repositories/user_repository_impl.dart';
import 'package:catalog_admin/features/users/domain/repositories/user_repository.dart';
import 'package:catalog_admin/features/users/presentation/cubit/user_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  // ==================== Core ====================
  sl.registerLazySingleton<CacheHelper>(() => CacheHelper());

  // TODO: Add Dio when backend is ready
  // sl.registerLazySingleton<Dio>(() {
  //   final dio = Dio(BaseOptions(
  //     baseUrl: 'YOUR_BASE_URL',
  //     connectTimeout: const Duration(seconds: 30),
  //     receiveTimeout: const Duration(seconds: 30),
  //   ));
  //   return dio;
  // });

  // ==================== Auth Feature ====================
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(cacheHelper: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Cubits
  sl.registerFactory(() => AuthCubit(repository: sl()));

  // ==================== Dashboard Feature ====================
  // Data Sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Cubits
  sl.registerFactory(() => DashboardCubit(repository: sl()));

  // ==================== Profile Feature ====================
  // Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(cacheHelper: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Cubits
  sl.registerFactory(() => ProfileCubit(repository: sl()));

  // ==================== Promo Code Feature ====================
  // Data Sources
  sl.registerLazySingleton<PromoRemoteDataSource>(
    () => PromoRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<PromoRepository>(
    () => PromoRepositoryImpl(remoteDataSource: sl()),
  );

  // Cubits
  sl.registerFactory(() => PromoCubit(repository: sl()));

  // ==================== Payments Feature ====================
  // Data Sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(() => PaymentCubit(repository: sl()));

  // ==================== Transactions Feature ====================
  // Data Sources
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => TransactionCubit(repository: sl()));

  // ==================== Users Feature ====================
  // Data Sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => UserCubit(repository: sl()));

  // ==================== Subscriptions Feature ====================
  // Data Sources
  sl.registerLazySingleton<SubscriptionRemoteDataSource>(
    () => SubscriptionRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => SubscriptionCubit(repository: sl()));
}
