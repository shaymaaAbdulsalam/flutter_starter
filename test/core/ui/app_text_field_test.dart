import 'package:flutter/material.dart';
import 'package:flutter_starter/core/ui/forms/field_value.dart';
import 'package:flutter_starter/core/ui/inputs/app_text_field.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) =>
    MaterialApp(home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: child)));

void main() {
  testWidgets('renders label, required marker and FieldValue error',
      (tester) async {
    await tester.pumpWidget(_host(
      AppTextField(
        field: const FieldValue('', error: 'Name is required'),
        onChanged: (_) {},
        label: 'Full name',
        isRequired: true,
      ),
    ));

    // Label + required marker render as one rich text ("Full name *").
    expect(
      find.textContaining('Full name', findRichText: true),
      findsOneWidget,
    );
    expect(find.textContaining('*', findRichText: true), findsOneWidget);
    expect(find.text('Name is required'), findsOneWidget);
  });

  testWidgets('price variant groups display text but emits raw digits',
      (tester) async {
    String? emitted;
    await tester.pumpWidget(_host(
      AppTextField.price(
        field: const FieldValue(''),
        onChanged: (v) => emitted = v,
        label: 'Price',
        currencyLabel: 'IQD',
      ),
    ));

    await tester.enterText(find.byType(TextField), '1234567');
    // Display is grouped…
    expect(find.text('1,234,567'), findsOneWidget);
    // …but the bloc receives the raw value.
    expect(emitted, '1234567');
    expect(find.text('IQD'), findsOneWidget);
  });

  testWidgets('obscure field gets a working visibility toggle',
      (tester) async {
    await tester.pumpWidget(_host(
      AppTextField(
        field: const FieldValue(''),
        onChanged: (_) {},
        label: 'Password',
        obscureText: true,
      ),
    ));

    TextField textField() => tester.widget<TextField>(find.byType(TextField));
    expect(textField().obscureText, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();
    expect(textField().obscureText, isFalse);
  });

  testWidgets('phone variant normalizes Arabic digits and filters letters',
      (tester) async {
    String? emitted;
    await tester.pumpWidget(_host(
      AppTextField.phone(
        field: const FieldValue(''),
        onChanged: (v) => emitted = v,
        label: 'Phone',
      ),
    ));

    await tester.enterText(find.byType(TextField), '٠٧٧٠abc123');
    expect(emitted, '0770123');
  });
}
