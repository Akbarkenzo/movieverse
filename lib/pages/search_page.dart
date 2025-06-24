import 'package:flutter/material.dart';
import '../api/tmdb_api.dart';
import '../models/movie.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Movie>>? _moviesFuture;

  void _searchMovies(String query) {
    setState(() {
      _moviesFuture = TmdbApi().searchMovies(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search for a movie...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _searchMovies(_searchController.text);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onSubmitted: (query) {
              _searchMovies(query);
            },
          ),
        ),
        Expanded(
          child: _buildSearchResults(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_moviesFuture == null) {
      return const Center(child: Text('Enter a movie title to start searching.'));
    }

    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final movies = snapshot.data!;
          if (movies.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                leading: Image.network(
                  movie.fullPosterUrl,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(movie.title),
                subtitle: Text(movie.releaseDate),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPage(),
                      settings: RouteSettings(arguments: movie),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const Center(child: Text('No movies found.'));
        }
      },
    );
  }
}