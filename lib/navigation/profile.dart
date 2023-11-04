import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:torrentx/navigation/favourite_movies.dart';
import 'package:torrentx/utils/now_playing.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/firebase_auth_controller.dart';
import '../controller/tmdb_api_controller.dart';
import '../controller/tmdb_auth_controller.dart';
import '../model/movie_model.dart';

// ignore: must_be_immutable
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
  final _displayNameController = TextEditingController();
  bool _isLoading = false;
  bool isDisplayName = false;
  String _username = "";
  List<Results> _nowPlaying = [];

  void _getUserName() {
    if (mounted) {
      _tmdbAuthController.getAccount().then((value) {
        setState(() {
          _username = value;
        });
      });
    }
  }

  void setDisplayName(String name) async {
    await _firebaseAuthController
        .changeDisplayName(name)
        .then((value) => setState(() {
              isDisplayName = false;
            }));
  }

  @override
  void initState() {
    super.initState();
    isDisplayName = _firebaseAuthController.user.displayName!.isEmpty;
    _tmdbApiController.fetchNowPlaying(1).then((value) => setState(() {
          _nowPlaying = value;
        }));
  }

  bool checkSession() {
    _tmdbAuthController.checkUserSession();
    return _tmdbAuthController.isValid.value;
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
    // widget.isMount = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: isDisplayName
                            ? Row(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: TextField(
                                      controller: _displayNameController,
                                      decoration: InputDecoration(
                                        hintText: "Enter your name",
                                        hintStyle: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        _firebaseAuthController
                                            .changeDisplayName(
                                                _displayNameController.text);
                                      },
                                      child: const Text("Update"))
                                ],
                              )
                            : Text(
                                _firebaseAuthController.user.displayName!,
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              )),
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
            const NowPlaying()
          ],
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
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.teal.withOpacity(0.45)),
                padding: const EdgeInsets.all(10),
                child: Obx(() {
                  if (_firebaseAuthController.validSession.value) {
                    _getUserName();
                    return Visibility(
                      visible: checkSession(),
                      child: Column(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      //Method yet to be prepared.
                                      _tmdbAuthController.logoutSession();
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
                                          color: Colors.white.withOpacity(0.6)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Visibility(
                      visible:
                          checkSession() ? checkSession() : !checkSession(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    "Sign in with TMDB account for managing data",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white)),
                              ),
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
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.person),
                                      prefixIconColor: Colors.white70,
                                      hintText: "TMDB Username",
                                      hintStyle: TextStyle(
                                          color:
                                              Colors.white70.withOpacity(0.65)),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
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
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.lock),
                                        prefixIconColor: Colors.white70,
                                        hintText: "TMDB password",
                                        hintStyle: TextStyle(
                                            color: Colors.white70
                                                .withOpacity(0.65)),
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                      ),
                                      obscureText: true,
                                    );
                                  }),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            final String username =
                                                _usernameController.text.trim();
                                            final String password =
                                                _passwordController.text.trim();
                                            if (username.isNotEmpty &&
                                                password.isNotEmpty) {
                                              _tmdbAuthController
                                                  .validateWithUsernamePassword(
                                                      username, password);
                                            } else {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              Get.snackbar("Login Failed",
                                                  "Please fill all the fields",
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white);
                                            }
                                            if (_tmdbAuthController
                                                .isValid.value) {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          },
                                          style: ButtonStyle(backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            if (states.contains(
                                                MaterialState.pressed)) {
                                              return Colors.teal.shade300
                                                  .withOpacity(0.8);
                                            }
                                            return Colors.teal.shade300
                                                .withOpacity(0.8);
                                          })),
                                          child: const Text("Sign in")),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Don't have an account?",
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launchUrl(Uri.parse(
                                                "https://www.themoviedb.org/account/signup"));
                                          },
                                          child: Text(
                                            "Create an account",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Favorite(),
                        ),
                      );
                    },
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
        ),
      ),
    );
  }
}
