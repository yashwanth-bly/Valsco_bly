part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccessful extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginError extends LoginState {
  const LoginError(this.error);
  final String error;
  @override
  List<Object> get props => [error];
}

class RegistrationSuccess extends LoginState {
  @override
  List<Object> get props => [];
}
