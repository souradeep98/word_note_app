import 'package:flutter/material.dart';

import 'package:word_note_app/widgets/app_bar_title.dart';
import 'package:word_note_app/widgets/only_words_view.dart';
import 'package:word_note_app/widgets/search_bar.dart';

import 'package:word_note_app/route_names.dart';
import 'package:word_note_app/widgets/snackbar.dart';



class Home extends StatefulWidget
{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
{
  GlobalKey<ScaffoldMessengerState> _homeScaffoldMState = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context)
  {
    _debugNote('Called build().');
    return ScaffoldMessenger(
      key: _homeScaffoldMState,
      child: Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: AppBarTitle('Word Note'),
          actions:
          [
            PopupMenuButton<int>(
              tooltip: 'Options',
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: const Text('Word Database Manager'),
                ),
               const PopupMenuItem(
                  value: 2,
                  child: const Text('About'),
                ),
              ],
              onSelected: (value) async
              {
                switch (value)
                {
                  case 1:
                    await Navigator.pushNamed(context, wordDatabaseManagerPage);
                    break;
                  case 2:
                    Navigator.pushNamed(context, aboutPage);
                }
              },
            ),
          ], // Actions
        ),



        floatingActionButton: FloatingActionButton.extended(
            label: const Text('Add word'),
            tooltip: 'Add new word',
            icon: const Icon(Icons.add),
            onPressed: () async {
              var _x = await Navigator.pushNamed(context, addWordPage);
              if (_x != null)
              {
                showSnack(_homeScaffoldMState, 'Word added.');
              }
              _debugNote('Add word result: $_x'); // DEBUG
            }
        ),

        body: Column(
          children: [
            SearchBar(),
            OnlyWordsView(showSnack),
          ],
        ),
      ),
    );
  }
}

_debugNote(String s)
{
  debugPrint('HomePage: $s');
}