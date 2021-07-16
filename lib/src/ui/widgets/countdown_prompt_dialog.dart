import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class CountdownPromptDialog extends StatefulWidget {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String positiveButtonText,
    Color? positiveButtonColor,
    required VoidCallback onPositivePressed,
    Duration countdownDuration = const Duration(seconds: 3),
    bool barrierDismissable = true,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => CountdownPromptDialog(
        title: title,
        message: message,
        positiveButtonText: positiveButtonText,
        positiveButtonColor: positiveButtonColor,
        onPositivePressed: onPositivePressed,
      ),
      barrierDismissible: barrierDismissable,
    );
  }

  final String title;
  final String message;
  final String positiveButtonText;
  final Color? positiveButtonColor;
  final VoidCallback onPositivePressed;
  final Duration countdownDuration;

  const CountdownPromptDialog({
    required this.title,
    required this.message,
    required this.positiveButtonText,
    this.positiveButtonColor,
    required this.onPositivePressed,
    this.countdownDuration = const Duration(seconds: 5),
  }) : assert(countdownDuration >= const Duration(seconds: 1));

  @override
  _CountdownPromptDialogState createState() => _CountdownPromptDialogState();
}

class _CountdownPromptDialogState extends State<CountdownPromptDialog> {
  late final CountdownTimer _countdownTimer;

  @override
  void initState() {
    super.initState();

    _countdownTimer = CountdownTimer(
      widget.countdownDuration,
      Duration(milliseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        _countdownPositiveButton(
          countdownTimer: _countdownTimer,
          text: widget.positiveButtonText,
          color: widget.positiveButtonColor,
          onPressed: widget.onPositivePressed,
        ),
      ],
    );
  }

  Widget _countdownPositiveButton({
    required CountdownTimer countdownTimer,
    required String text,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return StreamBuilder(
      stream: countdownTimer,
      builder: (_, AsyncSnapshot<CountdownTimer> snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error!;
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return TextButton(
              onPressed: null,
              child: Text(text),
            );
          case ConnectionState.active:
            return TextButton(
              onPressed: null,
              child: Text('$text (${snapshot.data!.remaining.inSeconds})'),
            );
          case ConnectionState.done:
            return TextButton(
              onPressed: onPressed,
              child: Text(text, style: TextStyle(color: color)),
            );
        }
      },
    );
  }
}
