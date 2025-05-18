import 'package:flutter/cupertino.dart';
import 'package:student_initializer/util/controller/spell_checker_controller.dart';
import 'package:list_english_words/list_english_words.dart';

typedef SavedObservationCallback = void Function(String value);

class NewObservationFrom extends StatefulWidget {
  final SavedObservationCallback callback;

  const NewObservationFrom({super.key, required this.callback});

  @override
  State<NewObservationFrom> createState() => _NewObservationFormState();
}

class _NewObservationFormState extends State<NewObservationFrom> {
  final FocusNode _focusNode = FocusNode();

  final List<String> listErrorTexts = [];
  final List<String> listTexts = [];

  SpellCheckerController _controller = SpellCheckerController();

  @override
  void initState() {
    super.initState();
    _controller = SpellCheckerController(listErrorTexts: listErrorTexts);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleOnChange(String text) {
    _handleSpellCheck(text, true);
  }

  void _handleSpellCheck(String text, bool ignoreLastWord) {
    if (!text.contains(' ')) {
      return;
    }
    final List<String> arr = text.split(' ');
    if (ignoreLastWord) {
      arr.removeLast();
    }
    for (var word in arr) {
      if (word.isEmpty) {
        continue;
      } else if (_isWordHasNumberOrBracket(word)) {
        continue;
      }
      final wordToCheck = word.replaceAll(RegExp(r"[^\s\w]"), '');
      final wordToCheckInLowercase = wordToCheck.toLowerCase();
      if (!listTexts.contains(wordToCheckInLowercase)) {
        listTexts.add(wordToCheckInLowercase);
        if (!list_english_words.contains(wordToCheckInLowercase)) {
          listErrorTexts.add(wordToCheck);
        }
      }
    }
  }

  bool _isWordHasNumberOrBracket(String s) {
    return s.contains(RegExp(r'[0-9\()]'));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CupertinoTextField(
            keyboardType: TextInputType.multiline,
            controller: _controller,
            focusNode: _focusNode,
            placeholder: "Enter Observation here ...",
            expands: false,
            minLines: 15,
            maxLines: 15,
            textInputAction: TextInputAction.newline,
            onChanged: _handleOnChange,
            onTapOutside: (value) =>
                {_focusNode.unfocus(), widget.callback(_controller.text)},
          ),
        ],
      ),
    );
  }
}
