import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(child: SpinKitFadingCircle(color: theme.primaryTextTheme.caption!.color,));
  }
}
