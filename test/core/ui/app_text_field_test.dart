import 'package:flutter/material.dart';
import 'package:flutter_starter/core/ui/forms/field_value.dart';
import 'package:flutter_starter/core/ui/inputs/app_text_field.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child) =>
    MaterialApp(home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: child)));

void main() {
  testWidgets('renders label and FieldValue error', (tester) async {
    await tester.pumpWidget(_host(
      AppTextField(
        field: const FieldValue('', error: 'Name is required'),
        onChanged: (_) {},
        label: 'Full name',
      ),
    ));

    expect(find.textContaining('Full name', findRichText: true), findsOneWidget);
    expect(find.text('Name is required'), findsOneWidget);
  });

  testWidgets('emits changed text', (tester) async {
    String? emitted;
    await tester.pumpWidget(_host(
      AppTextField(
        field: const FieldValue(''),
        onChanged: (v) => emitted = v,
        label: 'Email',
      ),
    ));

    await tester.enterText(find.byType(TextField), 'ada@example.com');
    expect(emitted, 'ada@example.com');
  });

  testWidgets('obscure field gets a working visibility toggle', (tester) async {
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
}
