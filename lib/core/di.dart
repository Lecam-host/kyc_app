import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:kyc_app/core/network/http/dio_client.dart';
import 'package:kyc_app/core/network/http/http_helper.dart';
import 'package:kyc_app/core/network/network_info.dart';
import 'package:kyc_app/core/routes/app_router.dart';
import 'package:kyc_app/core/storage/hive_helper.dart';
import 'package:kyc_app/features/auth/data/datasources/auth_local_ds.dart';
import 'package:kyc_app/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:kyc_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kyc_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:kyc_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:kyc_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kyc_app/features/kyc/data/datatsources/kyc_local_ds.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart' show KycModel;

final di = GetIt.instance;

Future<void> configureDependencies() async {
  final kycBox = await Hive.openBox<KycModel>("kycBox");
  di.registerLazySingleton(() => AppRouter());
  const sharedPreferences = FlutterSecureStorage();
  di.registerLazySingleton(() => sharedPreferences);
  di.registerLazySingleton<HiveHelper>(() => HiveHelper());
  // NETWORK INFO
  di.registerLazySingleton(() => DataConnectionChecker());
  di.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(di()));

  // HTTP HELPER
  di.registerLazySingleton<DioClient>(() => DioClient());
  di.registerLazySingleton<Dio>(() => DioClient().dio);
  di.registerLazySingleton<HttpHelper>(() => HttpHelper(di()));

  // AUTH
  di.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(di()),
  );

  di.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(di()));
  di.registerLazySingleton(
    () => AuthCubit(
      loginUseCase: di(),
      accountLocalDataSource: di(),
      registerUsecase: di(),
    ),
  );
  di.registerLazySingleton<LoginUseCase>(() => LoginUseCase(di()));

  di.registerLazySingleton<AccountLocalDataSourceImpl>(
    () => AccountLocalDataSourceImpl(sharedPreferences: di()),
  );
  di.registerLazySingleton<Box<KycModel>>(() => kycBox);

  di.registerLazySingleton<KycLocalDataSourceImpl>(
    () => KycLocalDataSourceImpl(di(), di()),
  );

  di.registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(di()));
}
