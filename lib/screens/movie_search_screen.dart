import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:omdb_api_with_bloc/blocs/movie_bloc/movie_bloc.dart';
import 'package:omdb_api_with_bloc/models/movie_model.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  late TextEditingController movieNameController;

  @override
  void initState() {
    super.initState();
    movieNameController = TextEditingController();
  }

  @override
  dispose() {
    movieNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: movieNameController,
              decoration: const InputDecoration(
                hintText: 'Write a movie name',
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    movieNameController.clear();
                    context.read<MovieBloc>().add(ClearTextEvent());
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Clear'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    String movieName = movieNameController.text.trim();
                    if (movieName.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please provide movie name');
                      return;
                    }

                    context.read<MovieBloc>().add(LoadMovieEvent(movieName: movieName));
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: BlocBuilder<MovieBloc, MovieState>(
                builder: (context, state) {
                  if (state is MovieInitial) {
                    return const Center(
                      child: Text('Type a movie name'),
                    );
                  }

                  if (state is MovieLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is MovieErrorState) {
                    return Center(
                      child: Text(state.message),
                    );
                  }

                  if (state is MovieLoadedState) {
                    return MovieWidget(movie: state.movie);
                  }

                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MovieWidget extends StatelessWidget {
  final MovieModel movie;
  const MovieWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.network(
          movie.poster!,
          width: 200,
          height: 400,
        ),
        ItemWidget(title: 'Title', value: movie.title!),
        ItemWidget(title: 'Actors', value: movie.actors!),
      ],
    );
  }
}

class ItemWidget extends StatelessWidget {
  final String title;
  final String value;

  const ItemWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple, width: 1.0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: [
        Text(
          title,
          style: const TextStyle(color: Colors.purple, fontSize: 18),
        ),
        const Divider(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ]),
    );
  }
}
