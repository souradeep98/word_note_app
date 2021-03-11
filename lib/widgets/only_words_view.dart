import 'package:flutter/material.dart';

import 'package:marquee_widget/marquee_widget.dart';
import 'package:provider/provider.dart';

import 'package:word_note_app/utilities/search_filter.dart';
import 'package:word_note_app/utilities/word_manager.dart';
import 'package:word_note_app/utilities/string_utilities.dart';

import 'package:word_note_app/route_names.dart';
import 'package:word_note_app/constants.dart';

//Not reusable
/*
This widget builds a list view of words from WordManager and also contains
a search bar for filtering the list items.
*/

class OnlyWordsView extends StatefulWidget
{
  final Function parentSnack;

  OnlyWordsView(this.parentSnack);

  final _OnlyWordsViewState _owvs= _OnlyWordsViewState();
  @override
  _OnlyWordsViewState createState() => _owvs;
}

class _OnlyWordsViewState extends State<OnlyWordsView>
{
  int printAndReturn(int i)
  {
    _debugNote('Called PrintAndReturn() with: $i');
    return i;
  }


  @override
  Widget build(BuildContext context)
  {
    _debugNote('Called build()');
    return Consumer2<WordManager, SearchFilter>(
      builder: (context, _wordManager, _filter, _) => Container(
        child: (_wordManager.words.isNotEmpty) ?
        Expanded(
          child: ListView.builder(
            cacheExtent: 20,
            itemCount: _wordManager.words.length,
            itemBuilder: (context, id) => ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _wordManager.words[printAndReturn(id) + 1].length,
              itemBuilder: (context, index) => (_wordManager.words[id + 1][index].toLowerCase().contains(_filter.getFilter.toLowerCase())) ?
              ListTile(
                dense: true,
                contentPadding: const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                title: Marquee(child: Text(_wordManager.words[id + 1][index].capitalizeFirst(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                  pauseDuration: const Duration(seconds: marqueeAfterRoundPauseDuration),
                  backDuration: const Duration(milliseconds: 75),
                ),
                onTap: () async
                {
                  var _x = await Navigator.pushNamed(context, wordDetailsPage, arguments: (id + 1));
                  if (_x is int)
                  {
                    widget.parentSnack('Word deleted.');
                  }
                },
              ) : null,
            ),
          ),
        ) : const Center(child: const Text('No words in list.')),
      )
      ,
    );
  }
}

void _debugNote(String s)
{
  debugPrint('OnlyWordsView: $s');
}