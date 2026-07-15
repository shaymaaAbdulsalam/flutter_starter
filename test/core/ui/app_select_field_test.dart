import 'package:flutter/material.dart';
import 'package:flutter_starter/core/ui/forms/field_value.dart';
import 'package:flutter_starter/core/ui/inputs/app_select_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens the picker sheet and returns the tapped item',
      (tester) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSelectField<String>(
            field: const FieldValue<String?>(null),
            items: const ['Iraq', 'Jordan', 'Egypt'],
            itemLabel: (item) => item,
            onChanged: (v) => selected = v,
            label: 'Country',
            hint: 'Select…',
          ),
        ),
      ),
    );

    // Hint shows while empty.
    expect(find.text('Select…'), findsOneWidget);

    await tester.tap(find.text('Select…'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Jordan'));
    await tester.pumpAndSettle();

    expect(selected, 'Jordan');
  });

  testWidgets('shows the selected value and FieldValue error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSelectField<String>(
            field: const FieldValue<String?>('Iraq', error: 'Pick another'),
            items: const ['Iraq', 'Jordan'],
            itemLabel: (item) => item,
            onChanged: (_) {},
            label: 'Country',
          ),
        ),
      ),
    );

    expect(find.text('Iraq'), findsOneWidget);
    expect(find.text('Pick another'), findsOneWidget);
  });
}
