import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kyc_app/core/network/http/dio_client.dart';
import 'package:kyc_app/core/network/http/http_helper.dart';
import 'package:kyc_app/core/network/network_info.dart';
import 'package:kyc_app/core/routes/app_router.dart';
import 'package:kyc_app/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:kyc_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kyc_app/features/auth/domain/repositories/auth_repo.dart';
import 'package:kyc_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:kyc_app/features/auth/presentation/cubit/auth_cubit.dart';

final di = GetIt.instance;

Future<void> configureDependencies() async {
  di.registerLazySingleton(() => AppRouter());

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
  di.registerLazySingleton<AuthCubit>(() => AuthCubit(di()));
  di.registerLazySingleton<LoginUseCase>(() => LoginUseCase(di()));
}
