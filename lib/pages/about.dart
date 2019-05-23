import 'package:flutter/material.dart';

class AboutUS extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("About us"),
        leading: new IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: new Center(
        child: new Text("This app Made by Omar Mohamed \n For contact :"),
      ),
    );
  }



}