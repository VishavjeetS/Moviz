import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/tmdb_api_controller.dart';
import '../model/movie_cast.dart';

class CastMembers extends StatefulWidget {
  final int id;
  const CastMembers({Key? key, required this.id}) : super(key: key);

  @override
  State<CastMembers> createState() => _CastMembersState();
}

class _CastMembersState extends State<CastMembers> {
  final _tmdbApiController = Get.put(TmdbApiController());
  List<Cast> _cast = [];

  @override
  void initState() {
    super.initState();
    _tmdbApiController.fetchMovieCast(widget.id).then((value) {
      setState(() {
        _cast = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _cast.isNotEmpty,
      child: Column(
        children: [
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
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(_castCast.profilePath ==
                                        null
                                    ? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
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
        ],
      ),
    );
  }
}
