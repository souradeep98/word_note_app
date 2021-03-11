import 'dart:collection';

import 'package:flutter/foundation.dart';

enum FeatureStatus
{
  completed, workingOn, coming
}

@immutable
class Feature
{
  final String featureName;
  final FeatureStatus status;
  Feature({@required this.featureName, @required this.status});
}

Future<void> generateFeatures() async
{
  debugPrint('Called generateFeatures()');
  featureList.forEach((element)
  {
    if (features[element.status] == null) {
      features[element.status] = [];
    }
    features[element.status].add(element.featureName);
  });
}

String featureToString(FeatureStatus featureStatus)
{
  switch (featureStatus)
  {
    case FeatureStatus.workingOn:
      return 'Working on:';
    case FeatureStatus.coming:
      return 'Coming:';
    case FeatureStatus.completed:
      return 'Completed:';
  }
  return 'Unknown:';
}


// Add features here with status. Change status as needed.
// Formality- Each feature contains Feature name(String) with its Status(FeatureStatus)
final List<Feature> featureList = [
  Feature(featureName: 'Stable', status: FeatureStatus.completed),
  Feature(featureName: 'Import and Export Database functionality', status: FeatureStatus.coming),
  Feature(featureName: 'Implement better loader for sake of humanity', status: FeatureStatus.coming),
  Feature(featureName: 'App Optimization', status: FeatureStatus.workingOn),
  Feature(featureName: 'Optimize Database', status: FeatureStatus.workingOn),
  Feature(featureName: 'Debug', status: FeatureStatus.workingOn),
  Feature(featureName: 'Listen to Words and Descriptions', status: FeatureStatus.workingOn),
  Feature(featureName: 'Get from share', status: FeatureStatus.workingOn),
];


HashMap<FeatureStatus, List<String>> features = HashMap<FeatureStatus, List<String>>();
