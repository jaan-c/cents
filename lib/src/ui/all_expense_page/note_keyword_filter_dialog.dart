import 'package:flutter/material.dart';

typedef SetNoteKeywordCallback = void Function(String);

class NoteKeywordFilterDialog extends StatefulWidget {
  static Future<void> show({
    required BuildContext context,
    required String? noteKeyword,
    required SetNoteKeywordCallback onSetNoteKeyword,
  }) async {
    await showDialog(
      context: context,
      builder: (_) => NoteKeywordFilterDialog(
        noteKeyword: noteKeyword,
        onSetNoteKeyword: onSetNoteKeyword,
      ),
    );
  }

  final String? noteKeyword;
  final SetNoteKeywordCallback onSetNoteKeyword;

  const NoteKeywordFilterDialog({
    required this.noteKeyword,
    required this.onSetNoteKeyword,
  });

  @override
  _NoteKeywordFilterDialogState createState() =>
      _NoteKeywordFilterDialogState();
}

class _NoteKeywordFilterDialogState extends State<NoteKeywordFilterDialog> {
  late final TextEditingController noteKeywordController;

  bool get isNoteKeywordField => noteKeywordController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    noteKeywordController = TextEditingController(text: widget.noteKeyword);
    noteKeywordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    noteKeywordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Cost Range'),
      content: _noteKeywordField(controller: noteKeywordController),
      actions: [
        _cancelButton(),
        _okButton(
          areRangeFieldsValid: isNoteKeywordField,
          noteKeywordController: noteKeywordController,
          onSetNoteKeyword: widget.onSetNoteKeyword,
        ),
      ],
    );
  }

  Widget _noteKeywordField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Note Keyword',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _cancelButton() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text('CANCEL'),
    );
  }

  Widget _okButton({
    required bool areRangeFieldsValid,
    required TextEditingController noteKeywordController,
    required SetNoteKeywordCallback onSetNoteKeyword,
  }) {
    return TextButton(
      onPressed: areRangeFieldsValid
          ? () {
              onSetNoteKeyword(noteKeywordController.text);
              Navigator.pop(context);
            }
          : null,
      child: Text('OK'),
    );
  }
}
