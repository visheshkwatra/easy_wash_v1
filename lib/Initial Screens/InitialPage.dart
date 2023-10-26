import 'package:flutter/material.dart';
import 'package:easy_wash_v1/Widgets/EzyWashLogo.dart';
import 'package:easy_wash_v1/HomePageScreens/HomePageMap.dart';
import 'package:easy_wash_v1/HomePageScreens/CarTypeSelection.dart';

import '../HomePageScreens/HomePage.dart';

class InitialPage extends StatefulWidget {
  static String id = "InitialPage";

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  bool isBikeSelected = false;

  void navigateToNextScreen(BuildContext context, bool isBikeSelected) {
    if (isBikeSelected) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return HomePageMap(isBikeSelected: isBikeSelected, selectedCarType: carTypeSelected,);
          },
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return CarSelectionScreen();
          },
        ),
      );
    }
  }

  Future<bool> isBikeCheck() async {
    return isBikeSelected;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0),
              child: EzyWashLogo(),
            ),
            buildOption(
              context,
              'IMAGES/carfinal2.png',
              'Car Cleanup',
              width: 350,
              height: 200,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CarSelectionScreen();
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            buildOption(
              context,
              'IMAGES/bike.png',
              'Bike Cleanup',
              width: 350,
              height: 200,
              onTap: () {
                setState(() {
                  isBikeSelected = true;
                });

                navigateToNextScreen(context, isBikeSelected);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOption(
      BuildContext context,
      String imagePath,
      String optionText, {
        required double width,
        required double height,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white10,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            optionText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitialPage(),
      routes: {
        // Define your routes here
      },
    );
  }
}
