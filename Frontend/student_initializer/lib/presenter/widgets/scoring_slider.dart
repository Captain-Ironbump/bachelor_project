import 'package:flutter/cupertino.dart';

typedef SliderCallback = void Function(double val);

class ScoringSlider extends StatefulWidget {
  final SliderCallback callback;

  const ScoringSlider({super.key, required this.callback});

  @override
  State<ScoringSlider> createState() => _ScoringSliderState();
}

class _ScoringSliderState extends State<ScoringSlider> {
  double _currentValue = 1.0;
  String? _sliderStatus;
  final Map<double, String> _lockupTable = {
    1.0: 'Mangelhaft',
    2.0: 'Schlecht',
    3.0: 'Befriedigend',
    4.0: 'Gut',
    5.0: 'Sehr gut',
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      _sliderStatus = setSliderStatus(_currentValue);
    });
  }

  String? setSliderStatus(double value) {
    return _lockupTable[value];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CupertinoSlider(
          key: const Key('slider'),
          value: _currentValue,
          divisions: 4,
          max: 5,
          min: 1,
          activeColor: CupertinoColors.activeBlue,
          thumbColor: CupertinoColors.activeBlue,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
              _sliderStatus = setSliderStatus(value)!;
            });
            widget.callback(value);
          },
        ),
        Text(
          _sliderStatus ?? '',
          style: CupertinoTheme.of(context)
              .textTheme
              .textStyle
              .copyWith(fontSize: 12),
        )
      ],
    );
  }
}
