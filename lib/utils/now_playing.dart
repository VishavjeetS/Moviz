import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/tmdb_api_controller.dart';
import '../model/movie_model.dart';
import '../screens/detail.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final _tmdbApiController = Get.put(TmdbApiController());
  List<Results> _nowPlaying = [];

  @override
  void initState() {
    super.initState();
    _tmdbApiController.fetchNowPlaying(1).then((value) => setState(() {
          _nowPlaying = value;
        }));
  }

  void loadMore() {
    _tmdbApiController
        .fetchNowPlaying(_nowPlaying.length ~/ 20 + 1)
        .then((value) => setState(() {
              _nowPlaying.addAll(value);
            }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 12),
                    child: Text(
                      "Now Playing",
                      style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ],
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _nowPlaying.length,
                  itemBuilder: (context, index) {
                    final list = _nowPlaying[index];
                    if (index == _nowPlaying.length - 1) {
                      loadMore();
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MovieDetail(
                                      movie: list,
                                    )));
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
                                  tag: list.id!,
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: NetworkImage(list.posterPath ==
                                                null
                                            ? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
                                            : "https://image.tmdb.org/t/p/w500" +
                                                list.posterPath!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    list.title == null ? "" : list.title!,
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
                  }),
            )
          ],
        ),
      ),
    );
  }
}
