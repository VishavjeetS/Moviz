import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:torrentx/controller/tmdb_api_controller.dart';
import 'package:torrentx/model/movie_model.dart';
import '../controller/tmdb_auth_controller.dart';
import '../model/movie_cast.dart';

class MovieDetail extends StatefulWidget {
  final Results movie;
  const MovieDetail({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetail> createState() => MovieDetailState();
}

class MovieDetailState extends State<MovieDetail> {
  final _tmdbApiController = Get.put(TmdbApiController());
  final _tmdbAuthController = Get.put(TmdbAuthController());
  List<Cast> _cast = [];
  List<Results> _similar = [];

  @override
  void initState() {
    super.initState();
    _tmdbAuthController.checkUserSession();
    _tmdbApiController.checkFav(widget.movie.id!);
    _tmdbApiController.fetchMovieCast(widget.movie.id!)
        .then((value) {
      setState(() {
        _cast = value;
      });
    });
    _tmdbApiController.fetchSimilarMovies(widget.movie.id!, 1)
        .then((value) {
      setState(() {
        _similar = value;
      });
    });
  }

  void loadMore() {
    _tmdbApiController.fetchSimilarMovies(widget.movie.id!, _similar.length ~/ 20 + 1)
        .then((value) {
      setState(() {
        _similar.addAll(value);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title!),
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
                    // height: MediaQuery.of(context).size.height / 2.5,
                    height: MediaQuery.of(context).size.height / 2.75,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}"),
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
                    child: Container(
                      height: 200,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500${widget.movie.posterPath}"),
                            fit: BoxFit.fill,
                          )),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Text(
                                    widget.movie.title!,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    widget.movie.overview!,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.teal,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Release Date",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    widget.movie.releaseDate!,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Language",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    widget.movie.originalLanguage!,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Popularity",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    widget.movie.popularity!.toInt().toString(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: Colors.teal,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Vote Count",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      widget.movie.voteCount!
                                          .toInt()
                                          .toString(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Vote Average",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      widget.movie.voteAverage!
                                          .toInt()
                                          .toString(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Adult",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      widget.movie.adult!.toString(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Cast Members",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 210,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _cast.length,
                      itemBuilder: (BuildContext context, int index) {
                        final _castCast = _cast[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: 150,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            _castCast.profilePath == null
                                                ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                                                : "https://image.tmdb.org/t/p/w500" +
                                                _castCast.profilePath!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _castCast.name == null ? "" : _castCast.name!,
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
                        );
                      },
                    ),
                  ),
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
                    height: 210,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _similar.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(index == _similar.length-1){
                          loadMore();
                        }
                        final _similarSimilar = _similar[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            width: 150,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            _similarSimilar.posterPath == null
                                                ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                                                : "https://image.tmdb.org/t/p/w500" +
                                                _similarSimilar.posterPath!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _similarSimilar.title == null ? "" : _similarSimilar.title!,
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.teal[900],
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if( _tmdbAuthController.isValid.value){
              if(!_tmdbApiController.addedToFav.value) {
                _tmdbApiController.addToFav(widget.movie.id!.toInt());
              }
              else{
                _tmdbApiController.removeFav(widget.movie.id!.toInt());
              }
            }
          },
          child: Obx(() => Icon(Icons.favorite,
            color: _tmdbApiController.addedToFav.value ? Colors.red : Colors.white,
          ))),
    );
  }
}
