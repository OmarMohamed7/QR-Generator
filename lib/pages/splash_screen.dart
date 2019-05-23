import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:qr_code_gen/pages/Login/login.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_gen/qr_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MaterialApp(home: Splash()));

final routes = {
  "/": (BuildContext context) => new Splash(),
  "/login" : (BuildContext context) => new Login(),
  "/home" : (BuildContext context) => new QRGenerator()
};

class Splash extends StatefulWidget{
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash> {

  SharedPreferences prefs;


  @override
  void initState(){
    super.initState();
    getDeviceDetails();
    Timer(Duration(seconds: 5) , onClose);
  }

  Future<void> onClose() async{
    prefs = await SharedPreferences.getInstance();
    final studentID = prefs.getString('StudentID');

    Navigator.of(context).pushReplacement(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => studentID == null ? new Login() :new QRGenerator(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, anim1, anim2, child) {
          return new FadeTransition(
            child: child,
            opacity: anim1,
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[

          //Container
          new Container(
            decoration: new BoxDecoration(color: Colors.blueGrey[300]),
          ),

          //Column
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(

                  child: new Column(
                    children: <Widget>[
                      new SizedBox(height: 50,),

                      new Container(
                        child:Image.asset('images/modern.png' , fit: BoxFit.fill,),
                        padding: EdgeInsets.fromLTRB(10, 0.0, 10, 0.0),
                      )


                    ],
                  ),
                ),


              new Expanded(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(padding: EdgeInsets.only(top: 15.0),),
                    Text("Loading" , style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold),)
                  ],
                )
              ),

            ],
          )


        ],
      ),
    );
  }

  Future<void> getDeviceDetails() async {
    String deviceID;
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("MACADDRESS") == null) {

      final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

      try {
        if (Platform.isAndroid) {
          var build = await deviceInfoPlugin.androidInfo;
          deviceID = build.androidId;
        } else if (Platform.isIOS) {
          var data = await deviceInfoPlugin.iosInfo;
          deviceID = data.identifierForVendor;
        }
      } on PlatformException {
        print('Failed to get platform version');
        deviceID = null;
      }
      
      prefs.setString("MACADDRESS", deviceID);

    }
  }


}