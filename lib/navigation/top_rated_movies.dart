import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/tmdb_api_controller.dart';
import '../model/movie_model.dart';
import '../screens/detail.dart';

class TopRated extends StatefulWidget {
  const TopRated({Key? key}) : super(key: key);

  @override
  State<TopRated> createState() => _TopRatedState();
}

class _TopRatedState extends State<TopRated> {
  final String _imagePath = "https://image.tmdb.org/t/p/w500";
  final _tmdbApiController = Get.put(TmdbApiController());
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
                  return ListView.builder(
                      physics:
                      const ScrollPhysics(parent: BouncingScrollPhysics()),
                      itemCount: _tmdbApiController.topRatedMovieList.length,
                      itemBuilder: (context, index) {
                        final Results movie =
                        _tmdbApiController.topRatedMovieList[index];
                        if (index ==
                            _tmdbApiController.topRatedMovieList.length - 1) {
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
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Container(
                                  width: 150,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              _imagePath + movie.posterPath!),
                                          fit: BoxFit.cover)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title!,
                                          style: GoogleFonts.poppins(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          movie.overview!,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Rating: ",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            Text(
                                              movie.voteAverage.toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }),
              ),
            ],
          )),
    );
  }
}
