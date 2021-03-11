import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:word_note_app/about/feature_list.dart';
import 'package:word_note_app/constants.dart';

class FeaturesWidget extends StatelessWidget
{
  final FeatureStatus featureStatus;

  FeaturesWidget(this.featureStatus);

  static const double featuresFontSize = 15;
  static const double featureHeaderFontSize = 16;
  static const double listTileHorizontalTitleGap = -14;

  FaIcon getIcon()
  {
    switch (featureStatus)
    {
      case FeatureStatus.workingOn:
        return const FaIcon(FontAwesomeIcons.circleNotch,
          size: featuresFontSize,
        );
      case FeatureStatus.coming:
        return const FaIcon(FontAwesomeIcons.clock,
          size: featuresFontSize,
        );
      case FeatureStatus.completed:
        return const FaIcon(FontAwesomeIcons.checkCircle,
          size: featuresFontSize,
        );
    }
    return FaIcon(FontAwesomeIcons.circle);
  }

  @override
  Widget build(BuildContext context)
  {
    FaIcon icon = getIcon();
    _debugNote('Called build() with: $featureStatus');
    return (features[featureStatus] != null) ? ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Text(featureToString(featureStatus),
          style: const TextStyle(
            fontSize: featureHeaderFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Card(
          elevation: 0,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: features[featureStatus].length,
            itemBuilder: (context, index) => ListTileMoreCustomizable(
              leading: icon,
              title: Marquee(
                child: Text(features[featureStatus][index],
                  style: const TextStyle(
                    fontSize: featuresFontSize,
                  ),
                ),
                pauseDuration: const Duration(seconds: marqueeAfterRoundPauseDuration),
                backDuration: const Duration(milliseconds: 75),
              ),
              dense: true,
              horizontalTitleGap: listTileHorizontalTitleGap,
            ),
          ),
        ),
      ],
    ) : const SizedBox(height: 0, width: 0,);
  }
}

void _debugNote(String s)
{
  debugPrint('FeaturesWidget: $s');
}
