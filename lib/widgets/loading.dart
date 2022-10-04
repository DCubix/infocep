import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({ this.color, super.key});

  final Color? color;

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SpinKitFadingCircle(
        color: widget.color ?? theme.primaryColor,
        duration: const Duration(milliseconds: 400),
        size: 32.0,
      ),
    );
  }
}
