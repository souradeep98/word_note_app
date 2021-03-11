/*
For initializing DBHelper and SingleWordManager
*/

import 'package:flutter/material.dart';
import 'package:word_note_app/about/feature_list.dart';

import 'package:word_note_app/device_properties.dart';
import 'package:word_note_app/route_names.dart';

import 'package:word_note_app/utilities/database_helper.dart';



class Splash extends StatefulWidget
{
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>
{
  final DBHelper _wordDB = DBHelper();

  Future<void> _initialize() async
  {
    await _wordDB.initialize();
    await generateFeatures();
    _debugNote('Requirements ready!');
    if (mounted) Navigator.pushReplacementNamed(context, homePage);
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context)
  {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 30),
            const Text('Wait till database is loading...'),
          ],
        ),
      ),
    );
  }
}

void _debugNote(String s)
{
  debugPrint('Splash: $s');
}
