import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyc_app/features/auth/data/datasources/auth_local_ds.dart';
import 'package:kyc_app/features/auth/data/models/user_model.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final AccountLocalDataSourceImpl accountLocalDataSource;
  AuthCubit({required this.loginUseCase, required this.accountLocalDataSource})
    : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(email, password);
      await accountLocalDataSource.saveData(
        UserModel(id: user.id, email: user.email, token: user.token),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      await accountLocalDataSource.saveData(
        UserModel(id: "1", email: "user.email", token: "user.token"),
      );

      emit(AuthError(e.toString()));
    }
  }

  Future<void> getCurrentUser() async {
    emit(AuthLoading());
    try {
      final user = await accountLocalDataSource.loadData();
      if (user == null) {
        emit(AuthLoggedOut());
        return;
      }
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await accountLocalDataSource.deleteData();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
