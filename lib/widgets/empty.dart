import 'package:flutter/material.dart';

enum EmptyState {
  empty,
  error
}

const _emptyStateImages = {
  EmptyState.empty: 'assets/empty.png',
  EmptyState.error: 'assets/warning.png'
};

class Empty extends StatelessWidget {
  const Empty({ required this.state, required this.message, super.key});

  final EmptyState state;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w400,
      color: Colors.grey[600],
    );
    return Center(
      child: SizedBox(
        width: 250.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(_emptyStateImages[state]!, width: 100.0, color: Colors.grey[500],),
            const SizedBox(height: 16.0,),
            Text(message, style: textStyle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}