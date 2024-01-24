import 'package:equatable/equatable.dart';
import 'package:omdb_api_with_bloc/models/movie_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdb_api_with_bloc/repositories/movie_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository = MovieRepository();

  MovieBloc() : super(MovieInitial()) {
    on<MovieEvent>((event, emit) async {
      if (event is LoadMovieEvent) {
        emit(MovieLoadingState());

        try {
          MovieModel movie = await movieRepository.getMovie(movieName: event.movieName);

          emit(MovieLoadedState(movie: movie));
        } catch (e) {
          emit(MovieErrorState());
        }
      }
    });
  }
}
