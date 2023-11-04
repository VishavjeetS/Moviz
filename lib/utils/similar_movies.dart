import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/tmdb_api_controller.dart';
import '../model/movie_model.dart';
import '../screens/detail.dart';

class SimilarMovies extends StatefulWidget {
  final int movieId;
  const SimilarMovies({Key? key, required this.movieId}) : super(key: key);

  @override
  State<SimilarMovies> createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  final _tmdbApiController = Get.put(TmdbApiController());
  List<Results> _similar = [];

  @override
  void initState() {
    super.initState();
    _tmdbApiController.fetchSimilarMovies(widget.movieId, 1).then((value) {
      setState(() {
        _similar = value;
      });
    });
  }

  void loadMore() {
    _tmdbApiController
        .fetchSimilarMovies(widget.movieId, _similar.length ~/ 20 + 1)
        .then((value) {
      setState(() {
        _similar.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _similar.isNotEmpty,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Similar Movies",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 310,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _similar.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == _similar.length - 1) {
                  loadMore();
                }
                final _similarSimilar = _similar[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetail(
                          movie: _similarSimilar,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: 150,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Hero(
                              tag: _similarSimilar.id!,
                              child: Container(
                                width: 150,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(_similarSimilar
                                                .posterPath ==
                                            null
                                        ? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
                                        : "https://image.tmdb.org/t/p/w500" +
                                            _similarSimilar.posterPath!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _similarSimilar.title == null
                                    ? ""
                                    : _similarSimilar.title!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
