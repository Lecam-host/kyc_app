import 'package:get_it/get_it.dart';
import 'package:kyc_app/core/routes/app_router.dart';

final di = GetIt.instance;

Future<void> configureDependencies() async {
  di.registerLazySingleton(() => AppRouter());
}
