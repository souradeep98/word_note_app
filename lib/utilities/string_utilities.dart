import 'package:flutter/foundation.dart';

extension StringUtils on String
{
  String capitalizeFirst()
  {
    _debugNote('Called capitalizeFirst()');
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }

  String capitalizeAsSentence()
  {
    _debugNote('Called capitalizeAsSentence()');

    if (this.trim().endsWith('.')) return this.trim().capitalizeFirst();
    return '${this.trim().capitalizeFirst()}.';
  }
}

void _debugNote(String s)
{
  debugPrint('StringUtilities: $s');
}