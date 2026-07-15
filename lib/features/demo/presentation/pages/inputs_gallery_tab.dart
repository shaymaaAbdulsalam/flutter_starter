import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_starter/core/ui/forms/field_value.dart';
import 'package:flutter_starter/core/ui/inputs/app_select_field.dart';
import 'package:flutter_starter/core/ui/inputs/app_text_field.dart';

/// Component gallery for the input design system — every variant, plus a
/// "show errors" toggle to preview validation styling and a disabled specimen.
///
/// Deliberately uses plain local state (not a bloc): this is a *widget
/// gallery*, not a feature flow. Real forms follow the FieldValue +
/// bloc-validator pattern shown in `features/auth/.../login/`.
///
/// Specimen labels are intentionally not localized — they are sample content,
/// like the fake API data on the other tabs.
class InputsGalleryTab extends StatefulWidget {
  const InputsGalleryTab({super.key});

  @override
  State<InputsGalleryTab> createState() => _InputsGalleryTabState();
}

class _InputsGalleryTabState extends State<InputsGalleryTab> {
  var _name = const FieldValue('');
  var _bio = const FieldValue('');
  var _age = const FieldValue('');
  var _weight = const FieldValue('');
  var _phone = const FieldValue('');
  var _price = const FieldValue('');
  var _country = const FieldValue<String?>(null);
  var _password = const FieldValue('');
  bool _showErrors = false;

  static const _countries = [
    'Iraq', 'Jordan', 'Egypt', 'Saudi Arabia', 'UAE',
    'Kuwait', 'Qatar', 'Lebanon', 'Morocco', 'Tunisia',
  ];

  void _toggleErrors(bool value) {
    setState(() {
      _showErrors = value;
      _name = _name.copyWith(
          error: value ? 'Name is required' : null, clearError: !value);
      _phone = _phone.copyWith(
          error: value ? 'Invalid phone number' : null, clearError: !value);
      _country = _country.copyWith(
          error: value ? 'Pick a country' : null, clearError: !value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('demo.show_errors'.tr()),
          value: _showErrors,
          onChanged: _toggleErrors,
        ),
        const SizedBox(height: 8),
        AppTextField(
          field: _name,
          onChanged: (v) => setState(() => _name = _name.setValue(v)),
          label: 'Full name',
          hint: 'e.g. Ada Lovelace',
          isRequired: true,
        ),
        const SizedBox(height: 16),
        AppTextField(
          field: _password,
          onChanged: (v) => setState(() => _password = _password.setValue(v)),
          label: 'Password',
          hint: 'Visibility toggle is built in',
          obscureText: true,
        ),
        const SizedBox(height: 16),
        AppTextField.multiline(
          field: _bio,
          onChanged: (v) => setState(() => _bio = _bio.setValue(v)),
          label: 'Bio',
          description: 'Multiline text area (maxLines: 4)',
          hint: 'Tell us about yourself…',
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField.number(
                field: _age,
                onChanged: (v) => setState(() => _age = _age.setValue(v)),
                label: 'Age',
                hint: '0',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField.decimal(
                field: _weight,
                onChanged: (v) => setState(() => _weight = _weight.setValue(v)),
                label: 'Weight',
                hint: '0.0',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField.phone(
          field: _phone,
          onChanged: (v) => setState(() => _phone = _phone.setValue(v)),
          label: 'Phone number',
          hint: '07xx xxx xxxx',
          isRequired: true,
          prefixIcon: const Icon(Icons.phone_outlined),
        ),
        const SizedBox(height: 16),
        AppTextField.price(
          field: _price,
          onChanged: (v) => setState(() => _price = _price.setValue(v)),
          label: 'Price',
          description:
              'Groups thousands while typing; the bloc receives raw digits',
          hint: '0',
          currencyLabel: 'IQD',
        ),
        const SizedBox(height: 16),
        AppSelectField<String>(
          field: _country,
          items: _countries,
          itemLabel: (item) => item,
          onChanged: (v) =>
              setState(() => _country = FieldValue<String?>(v)),
          label: 'Country',
          hint: 'demo.select_hint'.tr(),
          isRequired: true,
          searchable: true,
          searchHint: 'demo.search_hint'.tr(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          field: const FieldValue('Read-only / disabled specimen'),
          onChanged: (_) {},
          label: 'Disabled',
          enabled: false,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
