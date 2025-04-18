import 'package:flutter/cupertino.dart';

class RetryButton extends StatelessWidget {
  const RetryButton({super.key, required this.retryAction, required this.text});

  final void Function() retryAction;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: CupertinoTheme.of(context).textTheme.textStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          child: Center(
            child: CupertinoButton(
              onPressed: () => retryAction.call(),
              child: const Text('Retry'),
            ),
          ),
        ),
      ],
    );
  }
}
