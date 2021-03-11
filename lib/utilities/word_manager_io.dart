import 'package:flutter/foundation.dart';

import 'package:word_note_app/utilities/word_manager.dart';

import 'package:word_note_app/structures/only_words.dart';


extension WordManagerIO on WordManager
{
  void add(OnlyWords w, [bool toNotify = true])
  {
    _debugNote('Add word called.');
    words[w.id] = w.words;
    WordManager.tWords += w.words.length;
    if (toNotify) notify();
  }

  void deleteAll([bool markAsReady = true])
  {
    _debugNote('Delete all called.');
    words.clear();
    WordManager.tWords = 0;
    if (markAsReady) notify();
  }

  void delete(int id, int lastID, [bool toNotify = true])
  {
    _debugNote('Delete called.');
    WordManager.tWords -= words[id].length;
    words.remove(id);
    if (id < lastID) {
      _debugNote('deleteID: $id is less than lastID: $lastID');
      words[id] = words[lastID];
      words.remove(lastID);
    }
    if (toNotify) notify();
  }

  void update(OnlyWords w, [bool toNotify = true])
  {
    _debugNote('Update called.');
    //words.update(w.id, (value) => w.words);
    WordManager.tWords -= words[w.id].length;
    words.remove(w.id);
    WordManager.tWords += w.words.length;
    words[w.id] = w.words;
    if (toNotify) notify();
  }

}

void _debugNote(String s)
{
  debugPrint('WordManagerIO: $s');
}