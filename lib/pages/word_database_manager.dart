import 'package:flutter/material.dart';

import 'package:filesize/filesize.dart';

import 'package:word_note_app/widgets/app_bar_title.dart';

import 'package:word_note_app/utilities/database_helper.dart';
import 'package:word_note_app/utilities/word_manager.dart';

import 'package:word_note_app/widgets/snackbar.dart';

class WordDatabaseManager extends StatefulWidget
{
  @override
  _WordDatabaseManagerState createState() => _WordDatabaseManagerState();
}

class _WordDatabaseManagerState extends State<WordDatabaseManager>
{
  GlobalKey<ScaffoldMessengerState> _wdbmScaffoldMState = GlobalKey<ScaffoldMessengerState>();

  final WordManager _wordManager = WordManager();
  final DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context)
  {
    _debugNote('Called build().');
    return ScaffoldMessenger(
      key: _wdbmScaffoldMState,
      child: Scaffold(

        appBar: AppBar(
          leading: const BackButton(),
          centerTitle: true,
          title: AppBarTitle('Word Database Manager'),
          actions: [
            PopupMenuButton<int>(
              tooltip: 'Options',
              itemBuilder: (context) => [
                const PopupMenuItem(
                  child: const Text('Import from file'),
                  value: 1,
                ),
                const PopupMenuItem(
                  child: const Text('Export to file'),
                  value: 2,
                ),
                const PopupMenuItem(
                  child: const Text('Clear database'),
                  value: 3,
                )
              ],
              onSelected: (value)
              {
                switch (value)
                {
                  case 1:
                    showSnack(_wdbmScaffoldMState, 'This feature will be available soon.');
                    break;
                  case 2:
                    showSnack(_wdbmScaffoldMState, 'This feature will be available soon.');
                    break;
                  case 3:
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content: const Text('This will clear all the existing data!'),
                          //contentPadding: EdgeInsets.all(10),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                                child: Text('YES',
                                  style: TextStyle(
                                    color: Colors.red[700],
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await _dbHelper.clearDB();
                                  setState(() {});
                                  showSnack(_wdbmScaffoldMState, 'Database cleared.');
                                } // onPressed
                            ),
                          ], // actions
                        )
                    ); // showDialog
                }
              },
            ),
          ],
        ),

        body: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            Text('Word count: ${_wordManager.words.length.toString()}',
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30,),
            Text('Total word count: ${_wordManager.nOfWords}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40,),
            Text('Word Database File Size: ${filesize(_dbHelper.databaseSize)}',
              style: const TextStyle(
                fontSize: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _debugNote(String s)
{
  debugPrint('WordDatabaseManagerPage: $s');
}
