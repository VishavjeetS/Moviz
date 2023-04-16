import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torrentx/navigation/favourite_movies.dart';
import 'package:torrentx/navigation/profile.dart';
import 'package:torrentx/navigation/top_rated_movies.dart';
import '../controller/firebase_auth_controller.dart';
import '../navigation/popular_movies.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  final _authController = Get.put(AuthController());
  final _queryController = TextEditingController();

  var query = "";
  var _currentIndex = 0;

  void updateQuery(String query) {
    setState(() {
      this.query = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
          icon: const Icon(Icons.hub),
          label: "Popular",
          backgroundColor: Colors.teal[900]),
      BottomNavigationBarItem(
          icon: const Icon(Icons.trending_up),
          label: "Top Rated",
          backgroundColor: Colors.teal[900]),
      BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: "Favorite",
          backgroundColor: Colors.teal[900]),
      BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: "Profile",
          backgroundColor: Colors.teal[900]),
    ];
    final List<Widget> navigation = [
      const Popular(),
      const TopRated(),
      const Favorite(),
      Profile()
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.downloading_outlined),
        title: SearchBox(),
        actions: [
          IconButton(
            onPressed: () {
              _authController.logoutUser();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: navigation,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        backgroundColor: Colors.teal[900],
        selectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container SearchBox() {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: TextField(
          controller: _queryController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _queryController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        /* Clear the search field */
                        _queryController.clear();
                        updateQuery("");
                      },
                    )
                  : const Text(""),
              hintText: 'Search...',
              border: InputBorder.none),
          focusNode:  FocusNode(),
          onChanged: (query) => updateQuery(query),
        ),
      ),
    );
  }
}
