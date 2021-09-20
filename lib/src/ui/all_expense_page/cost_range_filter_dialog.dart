import 'package:cents/src/database/amount_range.dart';
import 'package:cents/src/domain/amount.dart';
import 'package:flutter/material.dart';

typedef SetCostRangeCallback = void Function(AmountRange);

class CostRangeFilterDialog extends StatefulWidget {
  static Future<void> show({
    required BuildContext context,
    required AmountRange? costRange,
    required SetCostRangeCallback onSetCostRange,
  }) async {
    return showDialog(
      context: context,
      builder: (_) => CostRangeFilterDialog(
        costRange: costRange,
        onSetCostRange: onSetCostRange,
      ),
      barrierDismissible: false,
    );
  }

  final AmountRange? costRange;
  final SetCostRangeCallback onSetCostRange;

  CostRangeFilterDialog({
    required this.costRange,
    required this.onSetCostRange,
  });

  @override
  _CostRangeFilterDialogState createState() => _CostRangeFilterDialogState();
}

class _CostRangeFilterDialogState extends State<CostRangeFilterDialog> {
  late final TextEditingController startCostController;
  late final TextEditingController endCostController;

  bool get areRangeFieldsValid {
    try {
      AmountRange(
        Amount.parse(startCostController.text),
        Amount.parse(endCostController.text.trim().isNotEmpty
            ? endCostController.text
            : startCostController.text),
      );
      return true;
    } on FormatException {
      return false;
    } on AssertionError {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    startCostController =
        TextEditingController(text: widget.costRange?.start.toString());
    endCostController =
        TextEditingController(text: widget.costRange?.end.toString());

    startCostController.addListener(() => setState(() {}));
    endCostController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    startCostController.dispose();
    endCostController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Cost Range'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _startCostField(controller: startCostController),
          SizedBox(height: 8),
          _endCostField(controller: endCostController),
        ],
      ),
      actions: [
        _cancelButton(),
        _okButton(
          areRangeFieldsValid: areRangeFieldsValid,
          startCostController: startCostController,
          endCostController: endCostController,
          onSetCostRange: widget.onSetCostRange,
        ),
      ],
    );
  }

  Widget _startCostField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'Start Cost',
        hintText: '0.00',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _endCostField({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'End Cost',
        hintText: '0.00',
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
    required TextEditingController startCostController,
    required TextEditingController endCostController,
    required SetCostRangeCallback onSetCostRange,
  }) {
    return TextButton(
      onPressed: areRangeFieldsValid
          ? () {
              final amountRange = AmountRange(
                Amount.parse(startCostController.text),
                Amount.parse(endCostController.text.trim().isNotEmpty
                    ? endCostController.text
                    : startCostController.text),
              );
              onSetCostRange(amountRange);

              Navigator.pop(context);
            }
          : null,
      child: Text('OK'),
    );
  }
}
