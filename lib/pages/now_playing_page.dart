// lib/pages/now_playing_page.dart

import 'package:flutter/material.dart';
import '../api/tmdb_api.dart';
import '../models/movie.dart';
import 'detail_page.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    // Memulai proses fetch data saat halaman pertama kali dibuat
    _moviesFuture = TmdbApi().getNowPlayingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan loading indicator saat data sedang diambil
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Tampilkan pesan error jika terjadi kesalahan
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Jika data berhasil didapat, tampilkan dalam GridView
          final movies = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 kolom
              childAspectRatio: 2 / 3, // Rasio poster film
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  // Navigasi ke halaman detail saat poster di-tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPage(),
                      settings: RouteSettings(arguments: movie),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias, // Untuk membulatkan gambar
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    movie.fullPosterUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        } else {
          // Tampilan jika tidak ada data
          return const Center(child: Text('No movies found.'));
        }
      },
    );
  }
}