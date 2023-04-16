import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/firebase_auth_controller.dart';
import '../controller/tmdb_api_controller.dart';
import '../controller/tmdb_auth_controller.dart';
import '../model/movie_model.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);
  bool isMount = true;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _firebaseAuthController = Get.put(AuthController());
  final _tmdbAuthController = Get.put(TmdbAuthController());
  final _tmdbApiController = Get.put(TmdbApiController());
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _tmdbLogin = true;
  String _username = "";
  List<Results> _nowPlaying = [];

  void _getUserName() {
    _tmdbAuthController.getAccount().then((value) {
      if (widget.isMount) {
        setState(() {
          _username = value;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tmdbApiController.fetchNowPlaying(1).then((value) => setState(() {
          _nowPlaying = value;
        }));
  }

  void loadMore() {
    _tmdbApiController.fetchNowPlaying(_nowPlaying.length ~/ 20 + 1).then((value) => setState(() {
          _nowPlaying.addAll(value);
        }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.isMount = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        color: Colors.teal[900],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Profile",
                          style: GoogleFonts.poppins(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Name: ",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        _firebaseAuthController.user.displayName == null ||
                                _firebaseAuthController.user.displayName!.isEmpty
                            ? "No Name"
                            : _firebaseAuthController.user.displayName!,
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Email: ",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        _firebaseAuthController.user.email!,
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ]),
              tmdbLogin(),
              discoverMore()
            ],
          ),
        ),
      ),
    );
  }

  SizedBox tmdbLogin() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "TMDB Login Status",
                  style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Container(
                padding: const EdgeInsets.only(top: 10),
                child: Obx(() {
                  if (_firebaseAuthController.validSession.value) {
                    _getUserName();
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Logged in as $_username",
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    //Method yet to be prepared.
                                  },
                                  child: const Text("Logout")),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Click here if you want to delete or logout from current session.\nNote: This wont delete your Login info.",
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 12.0, right: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.tealAccent,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text(
                                      "Favourites",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.tealAccent,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text(
                                      "Watchlist",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  } else {
                    return Visibility(
                      visible: _tmdbLogin,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                  "Sign in with TMDB account for managing data",
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Column(
                              children: [
                                FormField(builder: (FormFieldState state) {
                                  return TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: _usernameController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      prefixIconColor: Colors.white70,
                                      hintText: "TMDB Username",
                                      hintStyle:
                                          TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: FormField(
                                      builder: (FormFieldState state) {
                                    return TextFormField(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      controller: _passwordController,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        prefixIconColor: Colors.white70,
                                        hintText: "TMDB password",
                                        hintStyle:
                                            TextStyle(color: Colors.white70),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                      obscureText: true,
                                    );
                                  }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        setState(() {
                                          _tmdbLogin = false;
                                        });
                                        final String username =
                                            _usernameController.text.trim();
                                        final String password =
                                            _passwordController.text.trim();
                                        _tmdbAuthController
                                            .validateWithUsernamePassword(
                                                username, password);
                                        if (_tmdbAuthController.isValid.value) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                      child: const Text("Sign in")),
                                ),
                                Visibility(
                                  visible: _isLoading,
                                  child: const SizedBox(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                })),
          ],
        ),
      ),
    );
  }

  SizedBox discoverMore() {
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
                    if(index == _nowPlaying.length - 1){
                      loadMore();
                    }
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
                                        list.posterPath == null
                                            ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                                            : "https://image.tmdb.org/t/p/w500" +
                                            list.posterPath!),
                                    fit: BoxFit.cover,
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
                    );;
                  }),
            )
          ],
        ),
      ),
    );
  }
}
