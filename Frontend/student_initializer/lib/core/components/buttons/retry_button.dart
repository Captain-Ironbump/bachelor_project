import 'package:flutter/cupertino.dart';

class RetryButton extends StatelessWidget {
  const RetryButton({super.key, required this.retryAction, required this.text});

  final void Function() retryAction;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Ensures the Column shrinks to fit its children
      children: [
        Text(
          text,
          style: CupertinoTheme.of(context).textTheme.textStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        // Removed the Expanded widget
        Center(
          child: CupertinoButton(
            onPressed: () => retryAction.call(),
            child: const Text('Retry'),
          ),
        ),
      ],
    );
  }
}

