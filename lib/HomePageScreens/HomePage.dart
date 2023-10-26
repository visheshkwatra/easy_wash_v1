import 'package:flutter/material.dart';
import 'package:easy_wash_v1/HomePageScreens/HomePageMap.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/map': (context) => HomePageMap(isBikeSelected: false, selectedCarType: 0,),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/map'); // Navigate to HomePageMap
          },
          child: Text('Open Google Maps'),
        ),
      ),
    );
  }
}
