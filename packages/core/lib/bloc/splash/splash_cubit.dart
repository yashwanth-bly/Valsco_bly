import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(SplashInitial());
  final AuthRepository _authRepository;

  void load() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 3));
    User? user = _authRepository.getUser();
    if (user == null) {
      emit(SplashNavigateToLogin());
    } else {
      emit(SplashNavigateToHome());
    }
  }
}
