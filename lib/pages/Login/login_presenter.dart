import 'package:qr_code_gen/Model/autho.dart';
import 'package:qr_code_gen/Model/user.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginPageContract {
  void onLoginSuccess(User user);
  void onLoginError(String error);

}

SharedPreferences pref;
// pref = await SharedPreferences.getInstance();
//pref.setString("StudentID", _idTextController.text);

class LoginPresenter {
  static final String _AUTH_URL = "http://35.237.21.57:8080/Modern/Api/auth";
  static final String _GENERATOR_URL = "http://35.237.21.57:8080/Modern/Api/generator";

  LoginPageContract _view;

  LoginPresenter(this._view);

  var client;

  Future<void> doAuth(String userID, String userPassword) async {
    // call api
    //final Future<User> user;

    pref = await SharedPreferences.getInstance();

    User newUser = new User(userID, userPassword);

    await getAutho(_AUTH_URL, newUser, body: newUser.toMap());

    //await doLogin( _GENERATOR_URL , autho , newUser);

    // print("User : $userID \t Pass : $userPassword ");
    //print("Token : " + autho.toString() );
  }

  Future<void> getAutho(String url, User user,
      {Map<String, dynamic> body}) async {

    final res = await http.post(url, headers: {"Content-type": "application/json"},body: json.encode(body));

    final int statusCode = res.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      _view.onLoginError("Error");
      throw new Exception("Error while fetching");
    }else{
      Autho authoo = Autho.fromJson(json.decode(res.body));

      doLogin(_GENERATOR_URL, authoo, user);
    }

  }
  

  // Login Post request
  Future<void> doLogin(String generatorUrl, Autho autho, User user) async {
    // Headers
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + autho.token,
      "Content-type": "application/json",
      "userId": autho.userId,
    };

    // Body
    Map<String, dynamic> body = {
      "code": user.userID,
      "macAddress": pref.get("MACADDRESS")
    };

    final response = await http.post(generatorUrl,
        headers: requestHeaders, body: json.encode(body));

    if (response.statusCode == 200) {
      pref.setString("StudentID", user.userID);
      _view.onLoginSuccess(user);
    } else {
      await doPutRequest(generatorUrl, autho, user);
    }
  }

  // Login put request
  Future<void> doPutRequest(String generatorUrl, Autho autho, User user) async {
    // Headers
    Map<String, String> requestHeaders = {
      "Authorization": "Bearer " + autho.token,
      "Content-type": "application/json",
      "userId": autho.userId,
    };

    // Body
    Map<String, dynamic> body = {
      "code": user.userID,
      "macAddress": pref.get("MACADDRESS")
    };

    // Request
    http.put(generatorUrl, headers: requestHeaders, body: json.encode(body))
        .then((http.Response res) {
      if (res.statusCode == 200) {
        pref.setString("StudentID", user.userID);
        _view.onLoginSuccess(user);
      } else {
        _view.onLoginError("Error");
      }
    });
  }
}
