// lib/api/tmdb_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TmdbApi {
  // ======================================================================
  // !! PENTING !!
  // Ganti nilai di bawah ini dengan API Key Anda dari TMDB
  // ======================================================================
  static const String _apiKey = '8b6f4662b4daeb8bc571730b51e2fce8';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Fungsi untuk mengambil film yang sedang tayang (Now Playing)
  Future<List<Movie>> getNowPlayingMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/now_playing?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  // Fungsi untuk mengambil film populer
  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  // Fungsi untuk mencari film berdasarkan query
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final response = await http.get(Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&query=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to search movies');
    }
  }
}