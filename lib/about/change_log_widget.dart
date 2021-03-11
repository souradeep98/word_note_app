import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:word_note_app/about/change_log.dart';
import 'package:word_note_app/about/changes_widget.dart';
import 'package:word_note_app/constants.dart';
import 'package:word_note_app/widgets/popup_view.dart';

class ChangelogWidget extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return PopupView(
      title: 'Changelog',
      child: ListView.builder(
        itemCount: changelog.length,
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        itemBuilder: (context, index) => ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Marquee(
              child: Text('Version: ${changelog[index].version} - Build: ${changelog[index].buildNumber} - ${changelog[index].date.onlyDateToString()}',
                style: const TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              pauseDuration: const Duration(seconds: marqueeAfterRoundPauseDuration),
              backDuration: const Duration(milliseconds: 75),
            ),

            const SizedBox(height: 4,),

            ChangesWidget(index: index, changeType: ChangeType.added),

            ChangesWidget(index: index, changeType: ChangeType.changed),

            ChangesWidget(index: index, changeType: ChangeType.fixed),

            ChangesWidget(index: index, changeType: ChangeType.removed),

            const SizedBox(height: 20,),
          ],
        ),
      )
    );
  }
}
