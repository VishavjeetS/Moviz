import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:torrentx/model/movie_detail.dart';
import 'package:torrentx/model/movie_model.dart';
import 'package:torrentx/navigation/discover_more.dart';
import '../controller/tmdb_api_controller.dart';
import '../screens/detail.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final String _imagePath = "https://image.tmdb.org/t/p/w500";
  final _tmdbApiController = Get.put(TmdbApiController());
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Results> _movies = [];
  List<Genres> genereList = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _tmdbApiController.fetchGenre().then((value) => setState(() {
          genereList = value;
        }));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterData(String query) async {
    await _tmdbApiController.fetchSearch(query, 1).then((value) => setState(() {
          _movies = value;
        }));
  }

  void loadMore(String search) {
    _tmdbApiController
        .fetchSearch(search, _movies.length ~/ 20 + 1)
        .then((value) {
      setState(() {
        _movies.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            focusNode: _focusNode,
            controller: _textEditingController,
            onChanged: _filterData,
            decoration: const InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _textEditingController.clear();
                _filterData("");
              },
              icon: const Icon(Icons.clear),
            )
          ],
        ),
        body: Container(
            color: Colors.teal[900],
            child: _textEditingController.text.isNotEmpty
                ? ListView.builder(
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      if (index == _movies.length - 1) {
                        loadMore(_textEditingController.text);
                      }
                      Results movie = _movies[index];
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
                              Hero(
                                tag: movie.id!,
                                child: Container(
                                  width: 150,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            movie.posterPath == null
                                                ? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
                                                : _imagePath +
                                                    movie.posterPath!,
                                          ),
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
                                          ? movie.title!.substring(0, 23) +
                                              "..."
                                          : movie.title!,
                                      style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: Text(
                                        movie.title!.length < 15
                                            ? movie.overview!.length > 130
                                                ? movie.overview!
                                                        .substring(0, 130) +
                                                    "..."
                                                : movie.overview!
                                            : movie.overview!.length > 100
                                                ? movie.overview!
                                                        .substring(0, 80) +
                                                    "..."
                                                : movie.overview!,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
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
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    itemCount: genereList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 4),
                    ),
                    itemBuilder: (context, index) {
                      final genre = genereList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => DiscoverMore(
                                name: genre.name,
                                id: genre.id!,
                                isKeyWord: false,
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.tealAccent.shade100,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 13.0),
                            child: Row(
                              children: [
                                Text(
                                  genre.name!.length > 12
                                      ? "${genre.name!.substring(0, 12)}..."
                                      : genre.name!,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })));
  }
}
