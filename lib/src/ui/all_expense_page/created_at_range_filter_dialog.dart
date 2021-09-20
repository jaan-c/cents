import 'package:cents/src/domain/date_time_range.dart' as domain;
import 'package:flutter/material.dart';

typedef SetCreatedAtRangeCallback = void Function(domain.DateTimeRange);

class CreatedAtRangeFilterDialog {
  static Future<void> show({
    required BuildContext context,
    required domain.DateTimeRange? createdAtRange,
    required SetCreatedAtRangeCallback onSetCreatedAtRange,
  }) async {
    final dateTimeRange = await showDateRangePicker(
      context: context,
      initialDateRange: createdAtRange != null
          ? DateTimeRange(start: createdAtRange.start, end: createdAtRange.end)
          : null,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime(2100),
      saveText: 'OK',
    );

    if (dateTimeRange != null) {
      onSetCreatedAtRange(
        domain.DateTimeRange(dateTimeRange.start, dateTimeRange.end),
      );
    }
  }
}
