import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:torrentx/model/movie_model.dart';

import '../model/movie_cast.dart';
import '../model/movie_detail.dart';

class TmdbApiController extends GetxController {
  final _apiKey = "8f7e8262951851e9cd40e68b53f7df38";
  RxList movieList = RxList<Results>([]);
  RxList topRatedMovieList = RxList<Results>([]);
  RxList discoverMoreList = RxList<Results>([]);
  late MovieDetailModel details;
  RxBool isLoading = false.obs;
  RxBool addedToFav = false.obs;
  RxBool favLoaded = false.obs;
  String _sessionId = "";
  int page = 1;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  void fetchMovies() async {
    isLoading.value = true;
    List<dynamic> _fetchedMovies = await fetchPopularMovies(page);
    List<dynamic> _fetchedTopRatedMovies = await fetchTopRatedMovies(page);
    List<dynamic> _fetchedDiscoverMoreMovies = await fetchDiscoverMoreMovies();
    final List<Results> results =
        _fetchedMovies.map((movie) => Results.fromJson(movie)).toList();
    final List<Results> topRatedResults =
        _fetchedTopRatedMovies.map((movie) => Results.fromJson(movie)).toList();
    final List<Results> discoverMoreResults = _fetchedDiscoverMoreMovies
        .map((movie) => Results.fromJson(movie))
        .toList();
    movieList.addAll(results);
    topRatedMovieList.addAll(topRatedResults);
    discoverMoreList.addAll(discoverMoreResults);
    isLoading.value = false;
  }

  void nextPage() async {
    page += 1;
    fetchMovies();
  }

  Future<List<Results>> fetchSimilarMovies(int movieId, int page) async{
    final url = "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$_apiKey&language=en-US&page=$page";
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final jsonBody = json.decode(response.body);
      final List<Results> results = jsonBody['results'].map<Results>((movie) => Results.fromJson(movie)).toList();
      return results;
    }else{
      throw Exception('Failed to fetch similar movies - ${response.statusCode}');
    }
  }

  Future<List<Results>> fetchNowPlaying(int page) async{
    final url = "https://api.themoviedb.org/3/movie/now_playing?api_key=$_apiKey&language=en-US&page=$page";
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final jsonBody = json.decode(response.body);
      final List<Results> results = jsonBody['results'].map<Results>((movie) => Results.fromJson(movie)).toList();
      return results;
    }else{
      throw Exception('Failed to fetch now playing movies - ${response.statusCode}');
    }
  }

  Future<int> getAccount() async{
    final ref = await FirebaseDatabase.instance.ref().child('users').child(FirebaseAuth.instance.currentUser!.uid).once();
    final _data = ref.snapshot.value as Map<dynamic, dynamic>;
    _sessionId = _data['sessionId'];

    try{
      final String _getAccountDetailUrl = 'https://api.themoviedb.org/3/account?api_key=$_apiKey&session_id=$_sessionId';
      final response = await http.get(Uri.parse(_getAccountDetailUrl));
      if(response.statusCode == 200){
        final jsonBody = json.decode(response.body);
        return jsonBody['id'];
      }else{
        throw Exception('Failed to fetch account details - ${response.statusCode}');
      }
    }
    catch(_error){
      throw Exception('Failed to fetch account details - $_error');
    }
  }

  Future<void> removeFav(int movieId) async{
    final int _accountId = await getAccount();
    final url = Uri.https('api.themoviedb.org', '3/account/{account_id}/favorite');
    final headers = {'Content-Type': 'application/json;charset=utf-8'};
    final body = json.encode({
      'media_type': 'movie',
      'media_id': movieId,
      'favorite': false
    });
    final params = {
      'session_id': _sessionId,
      'api_key': _apiKey
    };
    final response = await http.post(url.replace(path: url.path.replaceAll('{account_id}', _accountId.toString()), queryParameters: params), headers: headers, body: body);
    if(response.statusCode == 200) {
      Get.snackbar("Success", "Removed from favourites");
      addedToFav.value = false;
    }
    else{
      throw Exception('Failed to remove from fav - ${response.statusCode}');
    }
  }

  Future<void> addToFav(int movieId) async{
    final int _accountId = await getAccount();
    final url = Uri.https('api.themoviedb.org', '3/account/{account_id}/favorite');
    final headers = {'Content-Type': 'application/json;charset=utf-8'};
    final body = json.encode({
      'media_type': 'movie',
      'media_id': movieId,
      'favorite': true
    });
    final params = {
      'session_id': _sessionId,
      'api_key': _apiKey
    };
    final response = await http.post(url.replace(path: url.path.replaceAll('{account_id}', _accountId.toString()), queryParameters: params), headers: headers, body: body);
    if(response.statusCode == 201) {
      Get.snackbar("Success", "Added to favourites");
      addedToFav.value = true;
    }
    else{
      throw Exception('Failed to add to fav');
    }
  }

  Future<void> checkFav(int movieId) async {
    final url = Uri.https('api.themoviedb.org', '3/account/{account_id}/favorite/movies');
    final response = await http.get(url.replace(path: url.path.replaceAll('{account_id}', (await getAccount()).toString()), queryParameters: {
      'session_id': _sessionId,
      'api_key': _apiKey
    }));

    if(response.statusCode == 200){
      final jsonBody = json.decode(response.body);
      final List<dynamic> _favMovies = jsonBody['results'] as List<dynamic>;
      final List<int> _favMoviesId = _favMovies.map((movie) => movie['id'] as int).toList();
      print(_favMoviesId);
      if(_favMoviesId.contains(movieId)){
        print('alr to fav');
        addedToFav.value = true;
      }
      else {
        addedToFav.value = false;
      }
    }
    else{
      throw Exception('Failed to check fav');
    }
  }

  Future<List<Results>> getFav() async {
    final url = Uri.https('api.themoviedb.org', '3/account/{account_id}/favorite/movies');
    final response = await http.get(url.replace(path: url.path.replaceAll('{account_id}', (await getAccount()).toString()), queryParameters: {
      'session_id': _sessionId,
      'api_key': _apiKey
    }));

    if(response.statusCode == 200){
      final jsonBody = json.decode(response.body);
      final List<dynamic> _favMovies = jsonBody['results'] as List<dynamic>;
      final List<Results> _favMoviesResult = _favMovies.map((movie) => Results.fromJson(movie)).toList();
      favLoaded.value = true;
      return _favMoviesResult;
    }
    else{
      throw Exception('Failed to check fav');
    }
  }

  Future<List<Cast>> fetchMovieCast(int movieId) async {
    final String movieCastUrl =
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$_apiKey&language=en-US';
    try {
      final response = await http.get(Uri.parse(movieCastUrl));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final cast = jsonBody['cast'] as List<dynamic>;
        final List<Cast> result =
            cast.map((cast) => Cast.fromJson(cast)).toList();
        return result;
      } else {
        throw Exception('Failed to fetch movie cast on fetchMovieCast');
      }
    } on HttpException catch (_error) {
      throw Exception('Failed to fetch movie cast on fetchMovieCast - $_error');
    }
  }

  Future<void> fetchMovieDetails(int movieId) async {
    final String movieDetailsUrl =
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey&language=en-US';
    try {
      final response = await http.get(Uri.parse(movieDetailsUrl));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        details = jsonBody as MovieDetailModel;
      } else {
        throw Exception('Failed to fetch movie details on fetchMovieDetails');
      }
    } on HttpException catch (_error) {
      throw Exception(
          'Failed to fetch movie details on fetchMovieDetails - $_error');
    }
  }

  Future<List<dynamic>> fetchDiscoverMoreMovies() async {
    final String discoverMoreMoviesUrl =
        'https://api.themoviedb.org/3/discover/movie?api_key=$_apiKey&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&page=1&with_watch_monetization_types=flatrate';
    try {
      final response = await http.get(Uri.parse(discoverMoreMoviesUrl));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final discoverMoreMovies = jsonBody['results'];
        return discoverMoreMovies;
      } else {
        throw Exception(
            'Failed to fetch discover more movies on fetchDiscoverMoreMovies');
      }
    } on HttpException catch (_error) {
      throw Exception(
          'Failed to fetch discover more movies on fetchDiscoverMoreMovies - $_error');
    }
  }

  Future<List<dynamic>> fetchTopRatedMovies(int page) async {
    final String topRatedMoviesUrl =
        'https://api.themoviedb.org/3/movie/top_rated?api_key=$_apiKey&language=en-US&page=$page';
    try {
      final response = await http.get(Uri.parse(topRatedMoviesUrl));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final topRatedMovies = jsonBody['results'];
        return topRatedMovies;
      } else {
        throw Exception(
            'Failed to fetch top rated movies on fetchTopRatedMovies');
      }
    } on HttpException catch (_error) {
      throw Exception(
          'Failed to fetch top rated movies on fetchTopRatedMovies - $_error');
    }
  }

  Future<List<dynamic>> fetchPopularMovies(int page) async {
    final String popularMoviesUrl =
        'https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&language=en-US&page=$page';
    try {
      final response = await http.get(Uri.parse(popularMoviesUrl));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final popularMovies = jsonBody['results'];
        return popularMovies;
      } else {
        throw Exception('Failed to fetch popular movies on fetchPopularMovies');
      }
    } on HttpException catch (_error) {
      throw Exception(
          'Failed to fetch popular movies on fetchPopularMovies - $_error');
    }
  }
}
