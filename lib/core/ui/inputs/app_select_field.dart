import 'package:flutter/material.dart';

import 'package:flutter_starter/core/extensions/context_extension.dart';
import 'package:flutter_starter/core/ui/forms/field_value.dart';
import 'package:flutter_starter/core/ui/inputs/input_field_shell.dart';

/// Single-select field over any list of [T] — the kit's port of clinic360's
/// `SelectableInputField`, redesigned around a modal bottom sheet instead of
/// the `flutter_typeahead` overlay (mobile-first, zero extra dependencies,
/// and the sheet styling follows `BottomSheetTheme` from `AppThemeConfig`).
///
/// The trigger is an [InputDecorator], so it inherits the exact
/// `InputDecorationTheme` text fields use — change the input style in
/// `AppThemeConfig` and selects follow automatically.
///
/// Fully generic: pass [items] + [itemLabel]; works for enums, entities,
/// strings. Binds a `FieldValue<T?>` so bloc-validator errors render the same
/// way as on text fields. Set [searchable] for long lists.
class AppSelectField<T> extends StatelessWidget {
  const AppSelectField({
    super.key,
    required this.field,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.label,
    this.description,
    this.hint,
    this.sheetTitle,
    this.searchHint,
    this.isRequired = false,
    this.enabled = true,
    this.searchable = false,
    this.showError = true,
    this.itemSubtitle,
  });

  final FieldValue<T?> field;
  final List<T> items;

  /// Pre-localized display text for an item.
  final String Function(T item) itemLabel;
  final String Function(T item)? itemSubtitle;
  final ValueChanged<T> onChanged;

  final String? label;
  final String? description;
  final String? hint;
  final String? sheetTitle;
  final String? searchHint;
  final bool isRequired;
  final bool enabled;
  final bool searchable;
  final bool showError;

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _SelectSheet<T>(
        items: items,
        itemLabel: itemLabel,
        itemSubtitle: itemSubtitle,
        selected: field.value,
        title: sheetTitle ?? label,
        searchable: searchable,
        searchHint: searchHint,
      ),
    );
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final value = field.value;
    final hasError = field.hasError;

    return InputFieldShell(
      label: label,
      description: description,
      error: field.error,
      isRequired: isRequired,
      enabled: enabled,
      showError: showError,
      child: InkWell(
        onTap: enabled ? () => _openPicker(context) : null,
        borderRadius: BorderRadius.circular(8),
        child: InputDecorator(
          isEmpty: value == null,
          decoration: InputDecoration(
            hintText: hint,
            enabled: enabled,
            error: hasError ? const SizedBox.shrink() : null,
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
          ),
          child: value == null
              ? null
              : Text(
                  itemLabel(value),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLarge,
                ),
        ),
      ),
    );
  }
}

class _SelectSheet<T> extends StatefulWidget {
  const _SelectSheet({
    required this.items,
    required this.itemLabel,
    required this.selected,
    required this.searchable,
    this.itemSubtitle,
    this.title,
    this.searchHint,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final String Function(T item)? itemSubtitle;
  final T? selected;
  final bool searchable;
  final String? title;
  final String? searchHint;

  @override
  State<_SelectSheet<T>> createState() => _SelectSheetState<T>();
}

class _SelectSheetState<T> extends State<_SelectSheet<T>> {
  String _query = '';

  List<T> get _filtered => _query.isEmpty
      ? widget.items
      : widget.items
          .where((item) => widget
              .itemLabel(item)
              .toLowerCase()
              .contains(_query.toLowerCase()))
          .toList();

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: widget.searchable ? 0.7 : 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Column(
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
              child: Text(widget.title!, style: context.textTheme.titleMedium),
            ),
          if (widget.searchable)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                autofocus: false,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == widget.selected;
                return ListTile(
                  title: Text(widget.itemLabel(item)),
                  subtitle: widget.itemSubtitle == null
                      ? null
                      : Text(widget.itemSubtitle!(item)),
                  selected: isSelected,
                  trailing: isSelected
                      ? Icon(Icons.check, color: context.colors.primary)
                      : null,
                  onTap: () => Navigator.of(context).pop(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
