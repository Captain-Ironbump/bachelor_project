import 'package:flutter/cupertino.dart';

class BaseIndicator extends StatelessWidget {
  const BaseIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}
