import 'package:flutter/material.dart';
import 'package:qr_code_gen/Model/user.dart';
import 'package:qr_code_gen/pages/Login/login_presenter.dart';
import 'package:qr_code_gen/qr_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> implements LoginPageContract {
  TextEditingController _idTextController = new TextEditingController();
  TextEditingController _passwordTextController = new TextEditingController();

  SharedPreferences pref;

  LoginPresenter _presenter;

  bool _isLoading;
  bool _autoValidate = false;
  bool _isErrorText = false;

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _presenter = new LoginPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    User _user = new User("", "");

    final Size screenSize = MediaQuery.of(context).size;

    // Login button
    var btn_Login = new Container(
        height: 60,
        width: screenSize.width,
        child: new RaisedButton(
          child: new Text(
            'Login',
            style: new TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: _submit,
          color: Colors.blue,
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
        ));

    // Login Form
    var loginForm = new SafeArea(
      child: new Column(
        children: <Widget>[
          new SizedBox(
            height: 20,
          ),
          //new Text("Login", textScaleFactor: 3.0,),

          new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: new Column(
                children: <Widget>[
                  // UserID text field
                  new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new TextFormField(
                      validator: validateID,
                      controller: _idTextController,
                      onSaved: (String val) {
                        _user.userID = val;
                      },
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          labelText: "ID",
                          labelStyle: new TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),

                  // UserPassword text field
                  new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new TextFormField(
                      validator: validatePassword,
                      obscureText: true,
                      onSaved: (String val) {
                        _user.userPassword = val;
                      },
                      controller: _passwordTextController,
                      decoration: new InputDecoration(
                          labelText: "Password",
                          labelStyle: new TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                  ),

                  //Button
                  new Padding(
                    padding: EdgeInsets.all(10),
                    child: btn_Login,
                  ),
                ],
              ),
            ),
        ],
      ),
    );

    // Error Text
    var errorText = new Center(
      child: new Text("Something wrong with your ID or password ! ", style: new TextStyle(fontSize: 18)),
    );

    return new Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            loginForm,
            _isLoading == true
                ? new Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: new CircularProgressIndicator(),
                  )
                : new Container(),

            _isErrorText == true ? new Padding(
              child: errorText,
              padding: EdgeInsets.all(5.0),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  String validateID(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your ID';
    }

    return null;
  }

  String validatePassword(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    return null;
  }

  void _submit() {
    FocusScope.of(context).requestFocus(new FocusNode());
    final form = _formKey.currentState;
    if (form.validate()) {
      setState(() {
        _isLoading = true;
        _isErrorText = false;
        form.save();
        _presenter.doAuth(_idTextController.text, _passwordTextController.text);
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }


  @override
  void onLoginSuccess(User user) {
    // TODO: implement onLoginSuccess
    setState(() {
      _isLoading = false;
      _isErrorText = false;
    });

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => QRGenerator()));
  }

  @override
  void onLoginError(String error) {
    setState(() {
      _isLoading = false;
      _isErrorText = true;
    });

  }
}
