import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:torrentx/screens/detail.dart';

import '../controller/tmdb_api_controller.dart';
import '../controller/tmdb_auth_controller.dart';
import '../model/movie_model.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  late TmdbApiController _tmdbApiController;
  late TmdbAuthController _tmdbAuthController;
  List<Results> _favMovies = [];

  @override
  void initState() {
    super.initState();
    _tmdbApiController = Get.put(TmdbApiController());
    _tmdbAuthController = Get.put(TmdbAuthController());
    _tmdbAuthController.checkUserSession();
    _tmdbApiController.getFav().then((value) => setState(() {
          _favMovies = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          color: Colors.teal[900],
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 12),
                    child: Text(
                      "Movies",
                      style: GoogleFonts.poppins(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Favourite Movies",
                      style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Obx(
                  () => _tmdbAuthController.isValid.value
                      ? _tmdbApiController.favLoaded.value ||
                              _favMovies.isNotEmpty
                          ? ListView.builder(
                              physics: const ScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              itemCount: _favMovies.length,
                              itemBuilder: (context, index) {
                                final Results movie = _favMovies[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => MovieDetail(movie: movie));
                                  },
                                  child: Hero(
                                    tag: movie.id!,
                                    child: Card(
                                      color: Colors.teal[900],
                                      child: ListTile(
                                        leading: Image.network(
                                          "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                                          height: 100,
                                          width: 100,
                                        ),
                                        title: Text(
                                          movie.title!,
                                          style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            _tmdbApiController
                                                .removeFav(movie.id!);
                                            setState(() {
                                              _favMovies.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : const Center(child: CircularProgressIndicator())
                      : const Center(
                          child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Please login to your TMDB Account view your favourite movies",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                ),
              ),
            ],
          )),
    );
  }
}
