import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:torrentx/model/movie_model.dart';

class MovieCard extends StatelessWidget {
  final Results movie;
  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String _imagePath = "https://image.tmdb.org/t/p/w500";
    return Container(
      margin: const EdgeInsets.all(10),
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Hero(
            tag: movie.id!,
            child: Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(movie.posterPath == null
                          ? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
                          : _imagePath + movie.posterPath!),
                      fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title!.length > 23
                      ? movie.title!.substring(0, 23) + "..."
                      : movie.title!,
                  style: GoogleFonts.poppins(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    movie.title!.length < 15
                        ? movie.overview!.length > 130
                            ? movie.overview!.substring(0, 130) + "..."
                            : movie.overview!
                        : movie.overview!.length > 100
                            ? movie.overview!.substring(0, 80) + "..."
                            : movie.overview!,
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
