import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torrentx/components/custom_movie_card.dart';
import 'package:torrentx/controller/tmdb_api_controller.dart';
import 'package:torrentx/screens/detail.dart';

import '../model/movie_model.dart';

class DiscoverMore extends StatefulWidget {
  final int id;
  final String? name;
  final bool isKeyWord;
  const DiscoverMore(
      {Key? key, required this.id, required this.name, required this.isKeyWord})
      : super(key: key);

  @override
  State<DiscoverMore> createState() => _DiscoverMoreState();
}

class _DiscoverMoreState extends State<DiscoverMore> {
  final _tmdbApiController = Get.put(TmdbApiController());
  List<Results> discoverMore = ([]);

  @override
  void initState() {
    super.initState();
    widget.isKeyWord
        ? _tmdbApiController
            .discoverMoreKeywords(widget.id, 1)
            .then((value) => setState(() {
                  discoverMore = value;
                }))
        : _tmdbApiController.discoverMore(widget.id, 1).then((value) {
            setState(() {
              discoverMore = value;
            });
          });
  }

  void loadMore() {
    widget.isKeyWord
        ? _tmdbApiController
            .discoverMoreKeywords(widget.id, discoverMore.length ~/ 20 + 1)
            .then((value) {
            setState(() {
              discoverMore.addAll(value);
            });
          })
        : _tmdbApiController
            .discoverMore(widget.id, discoverMore.length ~/ 20 + 1)
            .then((value) {
            setState(() {
              discoverMore.addAll(value);
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(widget.name!),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.teal.shade900),
        child: ListView.builder(
            itemCount: discoverMore.length,
            itemBuilder: (context, index) {
              if (index == discoverMore.length - 1) {
                // _tmdbApiController.nextPage();
                loadMore();
              }
              final movie = discoverMore[index];
              return GestureDetector(
                  onTap: () {
                    Get.to(() => MovieDetail(movie: movie));
                  },
                  child: MovieCard(movie: movie));
            }),
      ),
    );
  }
}
