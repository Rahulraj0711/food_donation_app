import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final Widget child;
  BackgroundImage({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container (
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/sky.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.lighten),
          )
        ),
      child: child,
    );
  }
}
