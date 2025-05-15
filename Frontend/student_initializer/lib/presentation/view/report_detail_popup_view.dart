import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/core/components/indicators/base_indicator.dart';
import 'package:student_initializer/presentation/cubits/markdown/get_markdown_by_id/get_markdown_by_id_cubit.dart';
import 'package:markdown_widget/markdown_widget.dart';

class ReportDetailPopupView extends StatelessWidget {
  final int reportId;
  final Function onCloseCallback;
  final Function onChangeRouteCallback;

  const ReportDetailPopupView({
    super.key,
    required this.reportId,
    required this.onCloseCallback,
    required this.onChangeRouteCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemGrey6,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: MyNav(
              reportId: reportId,
              onPressedCallback: () {},
              onCloseCallback: () {
                onCloseCallback(context);
              },
            ),
            pinned: true,
            floating: false,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child:
                        BlocBuilder<GetMarkdownByIdCubit, GetMarkdownByIdState>(
                      builder: (context, state) {
                        if (state is GetMarkdownByIdLoading) {
                          return const Center(
                            child: BaseIndicator(),
                          );
                        }
                        if (state is GetMarkdownByIdLoaded) {
                          return Localizations(
                            locale: const Locale('en', 'US'),
                            delegates: const [
                              DefaultMaterialLocalizations.delegate,
                              DefaultWidgetsLocalizations.delegate,
                              DefaultCupertinoLocalizations.delegate,
                            ],
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.8,
                              ),
                              child: MarkdownWidget(
                                data: state.markdownForm!.report!,
                              ),
                            ),
                          );
                        }
                        if (state is GetMarkdownByIdError) {
                          return Center(
                            child: Text(state.message!),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

typedef OnPressedCallback = void Function();

class MyNav extends SliverPersistentHeaderDelegate {
  final int reportId;
  final OnPressedCallback onPressedCallback;
  final Function onCloseCallback;

  const MyNav(
      {required this.reportId,
      required this.onPressedCallback,
      required this.onCloseCallback});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    TextStyle navTitleTextStyle =
        CupertinoTheme.of(context).textTheme.navTitleTextStyle;
    return Container(
      color: CupertinoColors
          .systemGrey6, // Set the header background color to systemGrey6
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          SizedBox(
            width: 40.0,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.clear_circled_solid),
              onPressed: () {
                //Navigator.of(context, rootNavigator: true).pop();
                onCloseCallback();
              },
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Report Details $reportId',
                style: navTitleTextStyle.copyWith(fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: CupertinoButton(
              onPressed: () {
                onPressedCallback();
              },
              child: const Icon(CupertinoIcons.arrow_right_circle_fill),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 70.0;

  @override
  double get minExtent => 70.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
