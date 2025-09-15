import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:kyc_app/core/network/http/dio_client.dart';
import 'package:kyc_app/core/network/http/http_helper.dart';
import 'package:kyc_app/core/network/network_info.dart';
import 'package:kyc_app/core/routes/app_router.dart';

final di = GetIt.instance;

Future<void> configureDependencies() async {
  di.registerLazySingleton(() => AppRouter());

  // NETWORK INFO
  di.registerLazySingleton(() => DataConnectionChecker());
  di.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(di()));

  // HTTP HELPER
  di.registerLazySingleton<DioClient>(() => DioClient());

  di.registerLazySingleton<HttpHelper>(() => HttpHelper(di()));
}
