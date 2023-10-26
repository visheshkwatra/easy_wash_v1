import 'package:flutter/material.dart';
import 'package:easy_wash_v1/Widgets/EzyWashLogo.dart';
/// Splash Screen
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EzyWashLogo(
                size: 220,
              ),
            ],
          ),
        ),
      ),
    );
  }
}