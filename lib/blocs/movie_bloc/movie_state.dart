part of 'movie_bloc.dart';

sealed class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

final class MovieInitial extends MovieState {}

class MovieLoadingState extends MovieState {}

class MovieLoadedState extends MovieState {
  final MovieModel movie;

  const MovieLoadedState({required this.movie});
}

class MovieErrorState extends MovieState {
  final String message;

  const MovieErrorState({required this.message});
}

class MovieNotFoundState extends MovieState {}
