import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:torrentx/components/custom_movie_card.dart';

import '../controller/tmdb_api_controller.dart';
import '../model/movie_model.dart';
import '../screens/detail.dart';

class TopRated extends StatefulWidget {
  const TopRated({Key? key}) : super(key: key);

  @override
  State<TopRated> createState() => _TopRatedState();
}

class _TopRatedState extends State<TopRated> {
  late TmdbApiController _tmdbApiController;

  @override
  void initState() {
    super.initState();
    _tmdbApiController = Get.put(TmdbApiController());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Top Rated Movies",
                      style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Obx(() {
                  return !_tmdbApiController.isLoading.value
                      ? ListView.builder(
                          physics: const ScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          itemCount:
                              _tmdbApiController.topRatedMovieList.length,
                          itemBuilder: (context, index) {
                            final Results movie =
                                _tmdbApiController.topRatedMovieList[index];
                            if (index ==
                                _tmdbApiController.topRatedMovieList.length -
                                    1) {
                              _tmdbApiController.nextPage();
                            }
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MovieDetail(
                                                movie: movie,
                                              )));
                                },
                                child: MovieCard(movie: movie));
                          })
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                }),
              ),
            ],
          )),
    );
  }
}
