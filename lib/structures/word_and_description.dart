import 'package:flutter/foundation.dart';

import 'package:word_note_app/structures/only_words.dart';


class WordAndDescription
{
  int id;
  List<String> words;
  List<String> descriptions;

  //constructors
  WordAndDescription({this.id, @required this.words, @required this.descriptions});

  WordAndDescription.fromMap(Map<String, dynamic> wordMap, {this.id})
  {
    _debugNote('Called Word::Word.fromMap() with map: $wordMap and id: ${this.id}');
    _debugNote('Adding the word list');
    words = (wordMap['word'] as List)?.map((e) => e as String)?.toList();
    _debugNote('Adding the description list');
    descriptions = (wordMap['description'] as List)?.map((e) => e as String)?.toList();
  }

  //toMap converter
  Map<String, dynamic> toMap() {_debugNote('Called Word::toMap()'); return {'word' : words, 'description' : descriptions};}

  //to OnlyWords
  OnlyWords toOnlyWords() => OnlyWords(id: id, words: words);
}

void _debugNote(String s)
{
  debugPrint('WordAndDescriptionStructure: $s');
}