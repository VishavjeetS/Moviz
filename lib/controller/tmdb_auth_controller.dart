import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TmdbAuthController extends GetxController {
  final _apiKey = "8f7e8262951851e9cd40e68b53f7df38";
  final _databaseRef = FirebaseDatabase.instance.ref();
  final _auth = FirebaseAuth.instance;
  RxBool isValid = false.obs;
  RxBool sessionIdRetrieved = false.obs;

  Future<void> checkUserSession() async {
    final _uid = _auth.currentUser!.uid;
    _databaseRef.child('users').child(_uid).onValue.listen((event) {
      final _data = event.snapshot;
      final _values = _data.value as Map<dynamic, dynamic>;
      if (_values["sessionId"].toString().isNotEmpty) {
        isValid.value = true;
      } else {
        isValid.value = false;
      }
    });
  }

  Future<String> getAccount() async{
    final ref = await FirebaseDatabase.instance.ref().child('users').child(FirebaseAuth.instance.currentUser!.uid).once();
    final _data = ref.snapshot.value as Map<dynamic, dynamic>;
    final _sessionId = _data['sessionId'];

    try{
      final String _getAccountDetailUrl = 'https://api.themoviedb.org/3/account?api_key=$_apiKey&session_id=$_sessionId';
      final response = await http.get(Uri.parse(_getAccountDetailUrl));
      if(response.statusCode == 200){
        final jsonBody = json.decode(response.body);
        return jsonBody['username'];
      }else{
        throw Exception('Failed to fetch account details - ${response.statusCode}');
      }
    }
    catch(_error){
      throw Exception('Failed to fetch account details - $_error');
    }
  }

  Future<String> fetchRequestToken() async {
    final String requestTokenUrl =
        'https://api.themoviedb.org/3/authentication/token/new?api_key=$_apiKey';
    try {
      final response = await http.get(Uri.parse(requestTokenUrl));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final requestToken = jsonBody['request_token'];
        return requestToken;
      } else {
        print(response.statusCode);
        throw Exception('Failed to fetch request token on fetchToken');
      }
    } on HttpException catch (_error) {
      throw Exception('Failed to fetch request token on fetchToken - $_error');
    }
  }

  Future<void> validateWithUsernamePassword(
      String username, String password) async {
    String _requestToken = await fetchRequestToken();
    try {
      final String validateUrl =
          'https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$_apiKey';
      final response = await http.post(Uri.parse(validateUrl), body: {
        'username': username,
        'password': password,
        'request_token': _requestToken,
      });
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final result = jsonBody['success'];
        final requestToken = jsonBody['request_token'];
        if (result) {
          createSession(requestToken);
        }
      } else {
        throw Exception('Failed to fetch request token on validateToken');
      }
    } on HttpException catch (_error) {
      throw Exception(
          'Failed to fetch request token on validateToken - $_error');
    }
  }

  Future<void> createSession(String _requestToken) async {
    final _uid = _auth.currentUser!.uid;
    final createSessionUrl =
        'https://api.themoviedb.org/3/authentication/session/new?api_key=$_apiKey';
    try {
      final response = await http.post(Uri.parse(createSessionUrl), body: {
        'request_token': _requestToken,
      });
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final _sessionId = jsonBody['session_id'];
        _databaseRef.child('users').child(_uid).update({
          'sessionId': _sessionId,
        });
        isValid.value = true;
        Get.offAllNamed('/home');
        Get.snackbar("Success", "Session Created");
      } else {
        isValid.value = false;
        throw Exception('Failed to create session');
      }
    } catch (error) {
      Future.error("Failed to create session - $error");
    }
  }
}
