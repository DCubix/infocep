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
  final List<InlineSpan> message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.headline6!.copyWith(
      fontWeight: FontWeight.w400,
      color: Colors.grey[600],
    );

    return Center(
      child: SizedBox(
        width: 300.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(_emptyStateImages[state]!, width: 100.0, color: Colors.grey[500],),
            const SizedBox(height: 10.0,),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: textStyle,
                children: message,
              ),
            ),
          ],
        ),
      ),
    );
  }
}