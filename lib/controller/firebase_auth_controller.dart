// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref();
  RxBool validSession = false.obs;
  late User user;
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    if (_auth.currentUser != null) {
      user = _auth.currentUser!;
      await checkUserSessionId();
    }
  }

  Future<void> checkUserSessionId() async {
    if (_auth.currentUser != null) {
      final _snapshot = await _database.child("users/${user.uid}").get();
      if (_snapshot.exists) {
        final _data = _snapshot.value as Map<dynamic, dynamic>;
        if (_data["sessionId"].isNotEmpty) {
          validSession.value = true;
        } else {
          validSession.value = false;
        }
      } else {
        Future.value("No snapshot available");
      }

      // print(_data["email"]);
      // print(data);
      // print(data["email"]);
      // if (data["sessionId"].isNotEmpty) {
      //   validSession.value = true;
      // } else {
      //   validSession.value = false;
      // }

      // _database.child("users").child(user.uid).onValue.listen((event) {
      //   var data = event.snapshot.value;
      //   if (data != null) {
      //     var user = data as Map<String, dynamic>;
      //     print(user["email"]);
      //     if (user["sessionId"].isNotEmpty) {
      //       validSession.value = true;
      //     } else {
      //       validSession.value = false;
      //     }
      //   } else {
      //     print("no data");
      //   }
      // });
    }
  }

  Future<void> registerUser(String email, String password) async {
    try {
      isLoading = true.obs;
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      isLoading.value = false;
    } on FirebaseAuthException catch (error) {
      Future.error(error);
      Get.snackbar("Error", error.message.toString());
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      isLoading = true.obs;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading.value = false;
      Get.offAllNamed('/home');
      Get.snackbar(email, "Logged In");
    } on FirebaseAuthException catch (error) {
      Get.snackbar("Error", error.toString());
      Future.error(error);
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut().then((value) {
      Get.offAllNamed('/');
      Get.snackbar("User", "Logged Out");
    });
  }
}
