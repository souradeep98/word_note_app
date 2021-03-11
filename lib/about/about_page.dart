import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:word_note_app/about/change_log_widget.dart';

import 'package:word_note_app/about/dependencies_used.dart';
import 'package:word_note_app/about/feature_list.dart';
import 'package:word_note_app/about/features_widget.dart';

import 'package:word_note_app/widgets/app_bar_title.dart';
import 'package:word_note_app/widgets/loading.dart';

import 'package:word_note_app/constants.dart';
import 'package:word_note_app/widgets/snackbar.dart';


class About extends StatelessWidget
{
  final GlobalKey<ScaffoldMessengerState> _aboutScaffoldMState = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: const BackButton(),
            centerTitle: true,
            title: AppBarTitle('Word Note'),
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: AppInfo(),
            ),
            expandedHeight: 120,
            stretch: true,
            actions: [
              IconButton(tooltip: 'Changelog', icon: Icon(Icons.history_toggle_off_rounded), onPressed: () async { await showDialog(context: context, builder: (context) => ChangelogWidget());})
            ],
          ),

          SliverList(
            delegate: SliverChildListDelegate(
              [
                Features(),
                const Divider(height: 5,),
                Dependencies(_aboutScaffoldMState),
              ]
            ),
          ),
        ],
      ),
    );
  }
}


//Contains app info
class AppInfo extends StatefulWidget
{
  @override
  _AppInfoState createState() => _AppInfoState();
}
class _AppInfoState extends State<AppInfo>
{
  PackageInfo _packageInfo;

  Future<bool> _prepare() async
  {
    _packageInfo = await PackageInfo.fromPlatform();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prepare(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Version: ${_packageInfo.version}'),
            const SizedBox(height: 8,),
            Text('Build number: ${_packageInfo.buildNumber}'),
            const SizedBox(height: 20,),
          ],
        );
      },
    );
  }
}





//Contains features
class Features extends StatefulWidget
{
  @override
  _FeaturesState createState() => _FeaturesState();
}
class _FeaturesState extends State<Features>
{
  void _debugNote(String s)
  {
    debugPrint('About::Features: $s');
  }

  @override
  Widget build(BuildContext context)
  {
    _debugNote('Features: $features');
    _debugNote('Called build().');
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 30),
      shrinkWrap: true,
      children: [
        const Center( //Heading
          child: const Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
            child: const Text('Feature Roadmap',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),

        //working on
        FeaturesWidget(FeatureStatus.workingOn),

        //coming
        FeaturesWidget(FeatureStatus.coming),

        //completed
        FeaturesWidget(FeatureStatus.completed),

      ],
    );
  }
}




//Contains package info and dependencies
class Dependencies extends StatelessWidget
{
  //final Function parentShowSnack;
  final GlobalKey<ScaffoldMessengerState> parentScaffoldMessengerState;

  Dependencies(this.parentScaffoldMessengerState);

  void _debugNote(String s)
  {
    debugPrint('About::Dependencies: $s');
  }

  @override
  Widget build(BuildContext context)
  {
    _debugNote('Called build().');
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(25),
      shrinkWrap: true,
      children: [
        const Text('Dependencies:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: dependencies.length,
          itemBuilder: (context, index) => ListTileMoreCustomizable(
            leading: const FaIcon(FontAwesomeIcons.infoCircle,
              size: 16,
            ),
            title: Marquee(child: Text(dependencies[index].name),
              pauseDuration: const Duration(seconds: marqueeAfterRoundPauseDuration),
              backDuration: const Duration(milliseconds: 75),
            ),
            onTap: (details) async
            {
              if (await canLaunch(dependencies[index].url))
              {
                await launch(dependencies[index].url);
              }
              else
              {
                showSnack(parentScaffoldMessengerState, 'Cannot launch URL: ${dependencies[index].url}');
              }
            },
            dense: true,
            horizontalTitleGap: -16,
          ),
        ),
      ],
    );
  }
}

