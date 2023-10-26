import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_wash_v1/Initial Screens/Splash.dart';
import 'package:easy_wash_v1/Initial Screens/InitialPage.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:easy_wash_v1/userSetup/AuthProvider.dart'; // Import your AuthProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Add other providers if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/initialPage': (context) => InitialPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.pushReplacementNamed(context, '/initialPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Splash();
  }
}
