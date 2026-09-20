import 'package:flutter/material.dart';

import 'package:flutter_starter/core/ui/forms/field_value.dart';
import 'package:flutter_starter/core/ui/inputs/input_field_shell.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.field,
    required this.onChanged,
    this.label,
    this.hint,
    this.enabled = true,
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  final FieldValue<String> field;
  final ValueChanged<String> onChanged;
  final String? label;
  final String? hint;
  final bool enabled;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final _controller = TextEditingController(text: widget.field.value);
  late bool _obscured = widget.obscureText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputFieldShell(
      label: widget.label,
      error: widget.field.error,
      enabled: widget.enabled,
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        obscureText: _obscured,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        onChanged: widget.onChanged,
        onSubmitted:
            widget.onSubmitted == null ? null : (_) => widget.onSubmitted!(),
        decoration: InputDecoration(
          hintText: widget.hint,
          error: widget.field.hasError ? const SizedBox.shrink() : null,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscured = !_obscured),
                )
              : null,
        ),
      ),
    );
  }
}
