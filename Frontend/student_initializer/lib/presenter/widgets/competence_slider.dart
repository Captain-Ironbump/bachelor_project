import 'package:flutter/cupertino.dart';
import 'package:student_initializer/presenter/widgets/scoring_slider.dart';

typedef CompetenceSliderCallback = void Function(Map<String, double>);

class CompetenceSlider extends StatefulWidget {
  final String competence;
  final List<String> indicators;
  final double height;
  final CompetenceSliderCallback callback;

  const CompetenceSlider(
      {super.key,
      required this.competence,
      required this.indicators,
      this.height = 150,
      required this.callback});

  @override
  State<CompetenceSlider> createState() => _CompetenceSliderState();
}

class _CompetenceSliderState extends State<CompetenceSlider> {
  final Map<String, double> _competenceValue = {};

  @override
  void initState() {
    super.initState();
    final entry = <String, double>{widget.competence: 1.0};
    _competenceValue.addEntries(entry.entries);
  }

  void updateMap(double val) {
    setState(() {
      _competenceValue[widget.competence] = val;
    });
    widget.callback(_competenceValue);
  }

  void _showSpeechBubble(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Indicator(s)'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.indicators.map((indicator) {
              return Text(indicator);
            }).toList(),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            height: widget.height,
          ),
          SizedBox(
            width: double.infinity,
            height: widget.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.competence,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => _showSpeechBubble(context),
                        child: const Icon(
                          CupertinoIcons.exclamationmark_circle_fill,
                          color: CupertinoColors.systemGrey,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ScoringSlider(
                      callback: (val) => updateMap(val),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
