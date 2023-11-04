import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:torrentx/components/custom_movie_card.dart';
import '../controller/tmdb_api_controller.dart';
import '../model/movie_model.dart';
import '../screens/detail.dart';

class Popular extends StatefulWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
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
                      "Popular Movies",
                      style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Obx(() => !_tmdbApiController.isLoading.value
                    ? ListView.builder(
                        physics: const ScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: _tmdbApiController.movieList.length,
                        itemBuilder: (context, index) {
                          final Results movie =
                              _tmdbApiController.movieList[index];
                          if (index ==
                              _tmdbApiController.movieList.length - 1) {
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
                    : const Center(child: CircularProgressIndicator())),
              ),
            ],
          )),
    );
  }
}
