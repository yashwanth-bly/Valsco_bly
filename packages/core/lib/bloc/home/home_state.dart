part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}
class HomeSuccess extends HomeState {
  final ValscoUser user;

  const HomeSuccess({required this.user});
  @override
  List<Object> get props => [user];
}
class HomeError extends HomeState {
  @override
  List<Object> get props => [];
}