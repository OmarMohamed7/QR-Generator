import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_gen/pages/about.dart';
import 'package:qr_code_gen/pages/splash_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';


import 'package:shared_preferences/shared_preferences.dart';

class QRGenerator extends StatefulWidget {

  @override
  _QRGeneratorState createState() => _QRGeneratorState();

}

class _QRGeneratorState extends State<QRGenerator>{

  SharedPreferences pref;

  String _dataString;
  var _encodedString;

  GlobalKey _globalKey = new GlobalKey();

  SharedPreferences _preferences;

  @override
  void initState(){
    super.initState();
    _getData();
    const seconds = const Duration(seconds: 15);
    new Timer.periodic(seconds, (Timer t) {
      _getData();
    });
  }

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
        child: new Scaffold(
          appBar: new AppBar(
            title: Text("Welcome"),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: new Container(),
            actions: <Widget>[
                            
              // For Logout
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: (){
                  _preferences.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Splash()));
                },
              ),

              // For info
              IconButton(
                icon: Icon(Icons.info),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUS()));
                },
              ),
            ],
          ),
          body:_contentWidget(),
        ),
        onWillPop: () { SystemNavigator.pop();} );
  }

  
   _contentWidget() {

    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          _pageToLoad
        ]
      )
    );
  }

  Widget get _pageToLoad{
    if(_dataString != null){
      return drawQR();
    }else{
      return drawLoading();
    }
  }

  Widget drawQR(){
    var bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return new Expanded(
      child:  Center(
        child: RepaintBoundary(
          key: _globalKey,
          child: QrImage(
            data: _encodedString,
            size:  0.5*bodyHeight,
            onError: (ex) {
              print("[QR] ERROR - $ex");
            },
          ),
        ),
      ),
    );
  }

  Widget drawLoading(){
    return new Container(
      child: new Center(
        child: CircularProgressIndicator(strokeWidth: 7.0,),
      )
    );
  }

  Widget _errorWidget(){
    return new Center(
      child: new Text("Error , Please restart the app !" , style: TextStyle(fontSize: 15.0),),
    );
  }


  Future<void> _getData() async{
    _preferences = await SharedPreferences.getInstance();
    _dataString = null;
    var bytes = null;
    _encodedString = null;

    var _screenShot = "1";

    //pref = await SharedPreferences.getInstance();

    final String mac = _preferences.getString("MACADDRESS");
    final String id = _preferences.getString("StudentID");

    var now = DateTime.now();
    now.toLocal();

    //1:88-53-2E-9A-55-C0:2019-04-26:18:52:52:10770

    if(mac != null && mac.length > 0 && id != null && id.length > 0) {
      _dataString = _screenShot+":"+ mac + ":" + now.toString() + ":" + id;
      bytes = utf8.encode(_dataString);

      setState(() {
        _encodedString = base64.encode(bytes);

        printt(_dataString , _encodedString);

      });

    }else{
      _errorWidget();
    }

    return _encodedString;
  }


  void printt( String data , String encodedData){
    debugPrint("Data : " + data);
    debugPrint("Encoded Data : " + encodedData);
  }


}

