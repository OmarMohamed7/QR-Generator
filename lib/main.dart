import 'package:flutter/material.dart';
import 'package:qr_code_gen/pages/Login/login.dart';
import 'package:qr_code_gen/pages/splash_screen.dart';
import 'package:qr_code_gen/qr_generator.dart';


final routes = {
  '/' : (BuildContext context) => new Splash(),
  '/login' : (BuildContext context) => new Login(),
  '/home' : (BuildContext context) => new QRGenerator(),
};


void main() => (runApp(new MaterialApp(
  initialRoute: '/',
  routes: routes,
)));