import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:word_note_app/about/change_log.dart';
import 'package:word_note_app/constants.dart';

class ChangesWidget extends StatelessWidget
{
  final int index;
  final ChangeType changeType;
  final double iconSize = 13;

  ChangesWidget({@required this.index, @required this.changeType});

  Icon getIcon()
  {
    switch (changeType)
    {
      case ChangeType.added:
        return Icon(Icons.add, size: iconSize,);
      case ChangeType.changed:
        return Icon(Icons.change_history_rounded, size: iconSize,);
      case ChangeType.fixed:
        return Icon(Icons.auto_fix_high, size: iconSize,);
      case ChangeType.removed:
        return Icon(Icons.remove, size: iconSize,);
    }
    return Icon(Icons.circle, size: iconSize,);
  }

  @override
  Widget build(BuildContext context)
  {
    Icon icon = getIcon();
    return (changelog[index].getChanges(changeType) != null) ? ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 6, 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Text(changeTypeToString(changeType),
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ), //heading
          const SizedBox(height: 2,),
          ListView.builder(
            padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 6, 0),
            itemCount: changelog[index].getChanges(changeType).length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, aindex) => Row(
              children: [
                icon,
                const SizedBox(width: 5,),
                Marquee(
                  child: Text(changelog[index].getChanges(changeType)[aindex]),
                  pauseDuration: const Duration(seconds: marqueeAfterRoundPauseDuration),
                  backDuration: const Duration(milliseconds: 75),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6,),
        ]
    ) : const SizedBox(height: 0, width: 0,);
  }
}
