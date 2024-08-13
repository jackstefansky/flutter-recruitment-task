import 'dart:ui';

class ColorUtils {
  /// Converts hex string to `Color`
  /// Returns null if hex string cannot be parsed
  static Color? fromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    final hex = int.tryParse(hexColor, radix: 16);

    if (hex == null) return null;

    return Color(hex);
  }
}
