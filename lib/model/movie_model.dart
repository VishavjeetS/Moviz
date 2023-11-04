// ignore_for_file: unnecessary_getters_setters

class MovieModel {
  int? _page;
  List<Results>? _results;
  int? _totalResults;
  int? _totalPages;

  MovieModel(
      {int? page, List<Results>? results, int? totalResults, int? totalPages}) {
    if (page != null) {
      _page = page;
    }
    if (results != null) {
      _results = results;
    }
    if (totalResults != null) {
      _totalResults = totalResults;
    }
    if (totalPages != null) {
      _totalPages = totalPages;
    }
  }

  int? get page => _page;
  set page(int? page) => _page = page;
  List<Results>? get results => _results;
  set results(List<Results>? results) => _results = results;
  int? get totalResults => _totalResults;
  set totalResults(int? totalResults) => _totalResults = totalResults;
  int? get totalPages => _totalPages;
  set totalPages(int? totalPages) => _totalPages = totalPages;

  MovieModel.fromJson(Map<String, dynamic> json) {
    _page = json['page'];
    if (json['results'] != null) {
      _results = <Results>[];
      json['results'].forEach((v) {
        _results!.add(Results.fromJson(v));
      });
    }
    _totalResults = json['total_results'];
    _totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = _page;
    if (_results != null) {
      data['results'] = _results!.map((v) => v.toJson()).toList();
    }
    data['total_results'] = _totalResults;
    data['total_pages'] = _totalPages;
    return data;
  }
}

class Results {
  String? _posterPath;
  bool? _adult;
  String? _overview;
  String? _releaseDate;
  List<int>? _genreIds;
  int? _id;
  String? _originalTitle;
  String? _originalLanguage;
  String? _title;
  String? _backdropPath;
  double? _popularity;
  int? _voteCount;
  bool? _video;
  dynamic _voteAverage;

  Results(
      {String? posterPath,
      bool? adult,
      String? overview,
      String? releaseDate,
      List<int>? genreIds,
      int? id,
      String? originalTitle,
      String? originalLanguage,
      String? title,
      String? backdropPath,
      double? popularity,
      int? voteCount,
      bool? video,
      dynamic voteAverage}) {
    if (posterPath != null) {
      _posterPath = posterPath;
    }
    if (adult != null) {
      _adult = adult;
    }
    if (overview != null) {
      _overview = overview;
    }
    if (releaseDate != null) {
      _releaseDate = releaseDate;
    }
    if (genreIds != null) {
      _genreIds = genreIds;
    }
    if (id != null) {
      _id = id;
    }
    if (originalTitle != null) {
      _originalTitle = originalTitle;
    }
    if (originalLanguage != null) {
      _originalLanguage = originalLanguage;
    }
    if (title != null) {
      _title = title;
    }
    if (backdropPath != null) {
      _backdropPath = backdropPath;
    }
    if (popularity != null) {
      _popularity = popularity;
    }
    if (voteCount != null) {
      _voteCount = voteCount;
    }
    if (video != null) {
      _video = video;
    }
    if (voteAverage != null) {
      _voteAverage = voteAverage;
    }
  }

  String? get posterPath => _posterPath;
  set posterPath(String? posterPath) => _posterPath = posterPath;
  bool? get adult => _adult;
  set adult(bool? adult) => _adult = adult;
  String? get overview => _overview;
  set overview(String? overview) => _overview = overview;
  String? get releaseDate => _releaseDate;
  set releaseDate(String? releaseDate) => _releaseDate = releaseDate;
  List<int>? get genreIds => _genreIds;
  set genreIds(List<int>? genreIds) => _genreIds = genreIds;
  int? get id => _id;
  set id(int? id) => _id = id;
  String? get originalTitle => _originalTitle;
  set originalTitle(String? originalTitle) => _originalTitle = originalTitle;
  String? get originalLanguage => _originalLanguage;
  set originalLanguage(String? originalLanguage) =>
      _originalLanguage = originalLanguage;
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get backdropPath => _backdropPath;
  set backdropPath(String? backdropPath) => _backdropPath = backdropPath;
  double? get popularity => _popularity;
  set popularity(double? popularity) => _popularity = popularity;
  int? get voteCount => _voteCount;
  set voteCount(int? voteCount) => _voteCount = voteCount;
  bool? get video => _video;
  set video(bool? video) => _video = video;
  dynamic get voteAverage => _voteAverage;
  set voteAverage(dynamic voteAverage) => _voteAverage = voteAverage;

  Results.fromJson(Map<String, dynamic> json) {
    _posterPath = json['poster_path'];
    _adult = json['adult'];
    _overview = json['overview'];
    _releaseDate = json['release_date'];
    _genreIds = json['genre_ids'].cast<int>();
    _id = json['id'];
    _originalTitle = json['original_title'];
    _originalLanguage = json['original_language'];
    _title = json['title'];
    _backdropPath = json['backdrop_path'];
    _popularity = double.parse(json['popularity'].toString());
    _voteCount = json['vote_count'];
    _video = json['video'];
    _voteAverage = json['vote_average'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['poster_path'] = _posterPath;
    data['adult'] = _adult;
    data['overview'] = _overview;
    data['release_date'] = _releaseDate;
    data['genre_ids'] = _genreIds;
    data['id'] = _id;
    data['original_title'] = _originalTitle;
    data['original_language'] = _originalLanguage;
    data['title'] = _title;
    data['backdrop_path'] = _backdropPath;
    data['popularity'] = _popularity;
    data['vote_count'] = _voteCount;
    data['video'] = _video;
    data['vote_average'] = _voteAverage;
    return data;
  }
}
