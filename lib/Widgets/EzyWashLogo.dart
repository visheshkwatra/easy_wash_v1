import 'package:flutter/material.dart';

class EzyWashLogo extends StatelessWidget {
  const EzyWashLogo({
    Key? key,
    this.size = 80.0,
    this.isBlack = true, // Add a property to control the logo color
  }) : super(key: key);

  final double size;
  final bool isBlack; // A property to control the logo color

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Image(
        image: isBlack
            ? AssetImage('IMAGES/EVX_Black.jpg')
            : AssetImage('IMAGES/EVX_White.png'),
        height: size,
        width: size,
        alignment: FractionalOffset.center,
      ),
    );
  }
}
