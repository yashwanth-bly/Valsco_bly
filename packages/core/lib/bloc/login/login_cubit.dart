import 'package:core/core.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(LoginInitial());
  final AuthRepository _authRepository;


  Future<void> googleSignIn() async {
    emit(LoginLoading());
    try {
      await _authRepository.signInWithGoogle();
      emit(RegistrationSuccess());
    } catch (e) {
      print(e);
      emit(LoginError(e.toString()));
    }
  }
}
