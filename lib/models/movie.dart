class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      overview: json['overview'] ?? 'No Overview',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? 'No Release Date',
    );
  }

  String get fullPosterUrl {
    if (posterPath.isNotEmpty) {
      return 'https://image.tmdb.org/t/p/w500$posterPath';
    }
    return 'https://via.placeholder.com/500x750.png?text=No+Image';
  }
}