import 'package:core/core.dart';
import 'package:core/models/models.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(HomeInitial());
  final AuthRepository _authRepository;

  Future<void> readUser() async {
    emit(HomeLoading());
    try {
      ValscoUser? user = await _authRepository.readUser();
      user ??= await _authRepository.addUser();
      emit(HomeSuccess(user: user));
    } catch (e) {
      emit(HomeError());
    }
  }
}
