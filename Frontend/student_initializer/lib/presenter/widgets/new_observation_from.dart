import 'package:flutter/cupertino.dart';

typedef SavedObservationCallback = void Function(String value);

class NewObservationFrom extends StatefulWidget {
  final SavedObservationCallback callback;

  const NewObservationFrom({super.key, required this.callback});

  @override
  State<NewObservationFrom> createState() => _NewObservationFormState();
}

class _NewObservationFormState extends State<NewObservationFrom> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoTextField(
          keyboardType: TextInputType.multiline,
          controller: _controller,
          focusNode: _focusNode,
          placeholder: "Enter Observation here ...",
          expands: true,
          minLines: null,
          maxLines: null,
          textInputAction: TextInputAction.newline,
          onTapOutside: (value) => {
            _focusNode.unfocus(),
            widget.callback(_controller.text)
          },
          suffix: CupertinoButton(
            child: const Icon(CupertinoIcons.clear),
            onPressed: () => _controller.clear(),
          ),
        ),
      ],
    );
  }
}
