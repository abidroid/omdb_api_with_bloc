import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:omdb_api_with_bloc/models/movie_model.dart';

class MovieRepository {
  Future<MovieModel> getMovie({required String movieName}) async {
    String url = 'https://www.omdbapi.com/?t=$movieName&apikey=94e188aa';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['Response'] == 'True') {
        MovieModel movie = MovieModel.fromJson(jsonResponse);
        return movie;
      } else {
        throw Exception('Not Found');
      }
    } else {
      throw Exception('Something went wrong');
    }
  }
}
