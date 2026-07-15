import 'package:flutter/material.dart';

/// Radius scale — the kit's shape signature.
///
/// Deliberately more generous than Material defaults: soft, confident corners
/// are what make the kit read as designed rather than default. Components get
/// their radius from `AppThemeConfig` (which defaults to these semantic
/// aliases), so changing the scale here — or overriding per-slot in the
/// config — reshapes the whole app.
abstract final class AppBorders {
  AppBorders._();

  // ── Scale ─────────────────────────────────────────────────────────────────

  /// 6 — badges, tiny affordances.
  static const BorderRadius xs = BorderRadius.all(Radius.circular(6));

  /// 10 — compact controls.
  static const BorderRadius sm = BorderRadius.all(Radius.circular(10));

  /// 14 — inputs and standard controls.
  static const BorderRadius md = BorderRadius.all(Radius.circular(14));

  /// 20 — cards, tiles, media.
  static const BorderRadius lg = BorderRadius.all(Radius.circular(20));

  /// 28 — dialogs, sheets, hero surfaces.
  static const BorderRadius xl = BorderRadius.all(Radius.circular(28));

  /// Pill / stadium.
  static const BorderRadius full = BorderRadius.all(Radius.circular(999));

  /// Bottom-sheet top corners.
  static const BorderRadius bottomSheet =
      BorderRadius.vertical(top: Radius.circular(28));

  // ── Semantic aliases (what AppThemeConfig defaults to) ───────────────────

  static const BorderRadius input = md;
  static const BorderRadius button = BorderRadius.all(Radius.circular(16));
  static const BorderRadius card = lg;
  static const BorderRadius chip = full;
  static const BorderRadius dialog = xl;

  // ── Shape helpers for ShapeBorder APIs ────────────────────────────────────

  static const RoundedRectangleBorder shapeSm =
      RoundedRectangleBorder(borderRadius: sm);
  static const RoundedRectangleBorder shapeMd =
      RoundedRectangleBorder(borderRadius: md);
  static const RoundedRectangleBorder shapeLg =
      RoundedRectangleBorder(borderRadius: lg);
  static const StadiumBorder stadium = StadiumBorder();
}
