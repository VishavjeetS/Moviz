import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:torrentx/controller/tmdb_api_controller.dart';
import 'package:torrentx/model/access_state.dart';
import 'package:torrentx/model/movie_model.dart';
import 'package:torrentx/model/video_model.dart';
import 'package:torrentx/utils/cast_members.dart';
import 'package:torrentx/utils/images.dart';
import 'package:torrentx/utils/movie_details.dart';
import 'package:torrentx/utils/reviews.dart';
import 'package:torrentx/utils/similar_movies.dart';
import 'package:torrentx/utils/youtube_player.dart';
import '../controller/tmdb_auth_controller.dart';

class MovieDetail extends StatefulWidget {
  final Results movie;
  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetail> createState() => MovieDetailState();
}

class MovieDetailState extends State<MovieDetail> {
  final _tmdbApiController = Get.put(TmdbApiController());
  final _tmdbAuthController = Get.put(TmdbAuthController());
  List<VideoResults> videos = [];
  AccessStateModel? accessState;

  @override
  void initState() {
    super.initState();
    _tmdbAuthController.checkUserSession();
    _tmdbApiController
        .accessState(widget.movie.id!)
        .then((value) => setState(() {
              accessState = value;
            }));
    if (_tmdbAuthController.isValid.value) {
      _tmdbApiController.checkFav(widget.movie.id!);
    }

    _tmdbApiController.fetchVideo(widget.movie.id!).then((value) {
      setState(() {
        videos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed("/home");
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.75,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.movie.backdropPath == null
                                ? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
                                : "https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}",
                          ),
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.dstATop)),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 4,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.teal[900],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                  ),
                ),
                Positioned(
                    top: 80,
                    left: 10,
                    bottom: 0,
                    child: Hero(
                      tag: widget.movie.id!,
                      child: Container(
                        height: 200,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.movie.posterPath == null
                                    ? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
                                    : "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}",
                              ),
                              fit: BoxFit.fill,
                            )),
                      ),
                    )),
                Positioned(
                  top: 175,
                  left: MediaQuery.of(context).size.width - 225,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width - 200,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Ratings",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          IgnorePointer(
                            ignoring: true,
                            child: RatingBar.builder(
                                itemCount: 5,
                                initialRating:
                                    ((widget.movie.voteAverage / 10) * 5),
                                itemBuilder: (context, _) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  );
                                },
                                onRatingUpdate: (rating) {}),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Column(
                children: [
                  // movieDetails(context),
                  MovieDescription(movie: widget.movie),
                  Images(id: widget.movie.id!),
                  CastMembers(id: widget.movie.id!),
                  // SizedBox(
                  //   height: 250,
                  //   width: double.infinity,
                  //   child: ListView.builder(
                  //     shrinkWrap: true,
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: videos.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       final _video = videos[index];
                  //       return Container(
                  //         child: _video.site == "YouTube"
                  //             ? YoutubePlayerScreen(videoId: _video.key!)
                  //             : Container(),
                  //       );
                  //     },
                  //   ),
                  // ),
                  SimilarMovies(movieId: widget.movie.id!),
                  Reviews(movieId: widget.movie.id!),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.teal[900],
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_tmdbAuthController.isValid.value) {
              if (!_tmdbApiController.addedToFav.value) {
                _tmdbApiController.addToFav(widget.movie.id!.toInt());
              } else {
                _tmdbApiController.removeFav(widget.movie.id!.toInt());
              }
            } else {
              Get.snackbar("Error", "Please Login to TMDB to add to favourites",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red.shade800,
                  colorText: Colors.white);
            }
          },
          // child: Icon(Icons.favorite,
          //     color: _tmdbAuthController.isValid.value
          //         ? accessState != null
          //             ? accessState!.favorite!
          //                 ? Colors.red
          //                 : Colors.white
          //             : Colors.white
          //         : Colors.white)),
          child: Obx(() => Icon(
                Icons.favorite,
                color: _tmdbApiController.addedToFav.value
                    ? Colors.red
                    : Colors.white,
              ))),
    );
  }
}
