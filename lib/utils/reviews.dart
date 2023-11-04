import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/tmdb_api_controller.dart';
import '../model/review_model.dart';

class Reviews extends StatefulWidget {
  final int? movieId;
  const Reviews({Key? key, required this.movieId}) : super(key: key);

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final _tmdbApiController = Get.put(TmdbApiController());
  List<ReviewResults> reviews = ([]);
  ReviewModel? reviewModel;
  @override
  void initState() {
    super.initState();
    _tmdbApiController
        .fetchReviews(widget.movieId!)
        .then((value) => setState(() {
              reviewModel = value;
              reviews = value.results!;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: reviews.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Reviews",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
                height: 300,
                width: double.infinity,
                child: reviewModel != null
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: reviewModel!.results!.length,
                        itemBuilder: (context, index) {
                          final _review = reviewModel!.results![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8),
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.teal.withOpacity(0.45)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8),
                                    child: ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                            _review.authorDetails!.avatarPath!
                                                    .contains("https")
                                                ? _review
                                                    .authorDetails!.avatarPath!
                                                : "https://image.tmdb.org/t/p/w500${_review.authorDetails!.avatarPath}",
                                            fit: BoxFit.fill,
                                            height: 50,
                                            width: 50, errorBuilder:
                                                (BuildContext context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                          return Image.network(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzOMbQ93iuu9WWPWGUVQuYPgcj1S1hFbN7HThRBowMLw&usqp=CAU&ec=48600113");
                                        }),
                                      ),
                                      title: Text(
                                        _review.author!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      // _review.content!.length > 330
                                      //     ? "${_review.content!.substring(0, 330)}..."
                                      //     :
                                      _review.content!,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white),
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : const Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    );
  }
}
