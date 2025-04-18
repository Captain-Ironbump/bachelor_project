import 'package:flutter/cupertino.dart';

class HomeView extends StatelessWidget {
  final String title;
  const HomeView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey6,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(title),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const Center(
                child: Text('Home lel'),
              )
            ]),
          )
        ],
      ),
    );
  }
}
