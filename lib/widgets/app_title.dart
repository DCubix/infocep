import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({ this.title, super.key});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/logo.png', height: 30.0),

        if (title != null) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.circle, size: 8.0),
          ),
          Text(title!)
        ],
      ],
    );
  }
}