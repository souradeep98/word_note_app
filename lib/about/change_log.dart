import 'package:flutter/foundation.dart';

enum ChangeType
{
  added, changed, fixed, removed
}

class Changelog
{
  final String version, buildNumber;
  final DateTime date;
  final List<String> changed;
  final List<String> added;
  final List<String> fixed;
  final List<String> removed;
  Changelog({@required this.version, @required this.buildNumber, @required this.date, this.added, this.changed, this.fixed, this.removed});

  List<String> getChanges(ChangeType changeType)
  {
    switch (changeType)
    {
      case ChangeType.added:
        return added;
      case ChangeType.changed:
        return changed;
      case ChangeType.fixed:
        return fixed;
      case ChangeType.removed:
        return removed;
    }
    return null;
  }
}

String changeTypeToString(ChangeType changeType)
{
  switch (changeType)
  {
    case ChangeType.added:
      return 'Added:';
    case ChangeType.changed:
      return 'Changed:';
    case ChangeType.fixed:
      return 'Fixed:';
    case ChangeType.removed:
      return 'Removed:';
  }
  return 'Unknown:';
}

extension DateTimeUtilities on DateTime
{
  onlyDateToString()
  {
    return '$day/$month/$year';
  }
}

// Add changelog of new build on top
// Formality- Changelog with the version(String),build number(String) and date(DateTime). Each changelog has four different data section - added, changed, fixed, removed. In the data section, change name(String) is to be added.
List<Changelog> changelog = [
  //new changelog goes here-


  Changelog(version: '1.0.0', buildNumber: '2', date: DateTime(2020, 11, 27),
    added: [
      'Changelog View',
    ],
    changed: [
      'Optimization',
    ],
    fixed: [
      'About Page UI'
    ],

  ),

  Changelog(version: '1.0.0', buildNumber: '1', date: DateTime(2020, 11, 20),
    added: [
      'About Page',
    ],
    fixed: [
      'Stable',
    ],
  ),
];