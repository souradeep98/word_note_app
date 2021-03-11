//database used: https://pub.dev/packages/sembast
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:word_note_app/structures/word_and_description.dart';

import 'package:word_note_app/constants.dart';
import 'package:word_note_app/utilities/word_manager.dart';
import 'package:word_note_app/utilities/word_manager_io.dart';


/*
The database is structured as:
int - Map<String 'word/description', List<String> word/description>
*/


class DBHelper
{
  // Private constructor
  DBHelper._privateConstructor()
  {
    _debugNote('Private constructor is called.');
  }

  // Static Initialization
  static final DBHelper _dbHelperSingletonInstance = DBHelper._privateConstructor();

  //static const String _dbName = 'wordnote.db', store_name = 'WORD_STORE'; //Name of the database file
  Directory dir; //directory to the application documents
  String _dbPath;
  StoreRef<int, dynamic> _store;
  Database _db;
  static bool _isReady = false;
  static int countOfWords = 0;
  int _dbSizeByte;




  bool get ready => _isReady;
  int get wordCount => countOfWords;

  // Factory constructor that returns the singleton instance
  factory DBHelper() => _dbHelperSingletonInstance;

  // SingleWordManager Instance
  final WordManager _wordManager = WordManager();



  Future<void> initializeWordManager() async
  {
    _wordManager.words.clear();
    int i;
    for (i = 1; i <= countOfWords; ++i) {
      WordAndDescription temp = await readWord(i); //DB operation
      _wordManager.add(temp.toOnlyWords(), false);
    }
    _debugNote('WordManager initialized.');
  }

  //constructor helper
  Future<bool> initialize() async
  {
    //get the application documents directory
    _debugNote('Getting application documents directory');
    dir = await getApplicationDocumentsDirectory();
    //make sure the directory exists
    _debugNote('Creating the directory');
    await dir.create(recursive: true);
    _debugNote('Directory created.');

    //open the database
    _dbPath = join(dir.path, databaseFN); //path + name
    _debugNote('Database path: $_dbPath');

    _debugNote('Opening the database');
    _db = await databaseFactoryIo.openDatabase(_dbPath);
    _debugNote('Database opened');

    _dbSizeByte = await File(_dbPath).length();
    _debugNote('Database file size $_dbSizeByte byte(s)');

    //storing utility initialized as int(auto-increment) - map
    _store = intMapStoreFactory.store(store_name);

    _debugNote('Getting count');
    countOfWords = await _store.count(_db);
    _debugNote('Count of records: $countOfWords'); // DEBUG

    _isReady = true;
    _debugNote('Database is ready to use');

    _debugNote('Initializing WordManager');
    await initializeWordManager();

    return true;
  }


  //Helper functions
  //add a single word
  Future<int> addWord(WordAndDescription w) async
  {
    _debugNote('Called DBHelper::addWord()');
    w.id = ++countOfWords;
    await _store.record(w.id).put(_db, w.toMap());
    _debugNote('The key for recent entry: $countOfWords'); // DEBUG
    _wordManager.add(w.toOnlyWords());
    _dbSizeByte = await File(_dbPath).length();
    _debugNote('Database file size $_dbSizeByte byte(s)');
    return countOfWords;
  }

  //read a single word
  Future<WordAndDescription> readWord(int id) async
  {
    _debugNote('Called DBHelper::readWord() at id: $id');
    return WordAndDescription.fromMap(await _store.record(id).get(_db), id: id);
  }

  //read all words
  Future<List<WordAndDescription>> readAllWords() async
  {
    _debugNote('Called DBHelper::readAllWords()');
    List<WordAndDescription> result = [];
    for (int id = 1; id <= countOfWords; ++id) {
      result.add(await readWord(id));
    }
    return result;
  }

  //update a single word
  Future<bool> updateWord(WordAndDescription w) async
  {
    _debugNote('Called DBHelper::updateWord() with: $w');
    await _db.transaction((txn) async
    {
      await _store.delete(txn, finder: Finder(filter: Filter.byKey(w.id)));
      await _store.record(w.id).put(txn, w.toMap());
    });
    _wordManager.update(w.toOnlyWords());
    _dbSizeByte = await File(_dbPath).length();
    _debugNote('Database file size $_dbSizeByte byte(s)');
    return true;
  }

  //delete a single word
  Future<bool> deleteWord(int id) async
  {
    _debugNote('Called DBHelper::deleteWord() with: $id');

    if (id < countOfWords) {
      await _db.transaction((txn) async
      {
        await _store.delete(txn, finder: Finder(filter: Filter.byKey(id))); //delete the asked word
        await _store.record(id).put(txn, await _store.record(countOfWords).get(txn)); //place the last word to the key/id
        await _store.delete(txn, finder: Finder(filter: Filter.byKey(countOfWords))); //delete the last word
      });
    }
    else {
      await _store.delete(_db, finder: Finder(filter: Filter.byKey(id)));
    } //if the last record is deleted
    _wordManager.delete(id, countOfWords);
    --countOfWords;
    _dbSizeByte = await File(_dbPath).length();
    _debugNote('Database file size $_dbSizeByte byte(s)');
    return true;
  }

  //delete all records
  Future clearDB() async
  {
    _debugNote('Called DBHelper::clearDB()');
    await _store.drop(_db);
    countOfWords = 0;
    _wordManager.deleteAll();
    _dbSizeByte = await File(_dbPath).length();
    _debugNote('Database file size $_dbSizeByte byte(s)');
  }

  //get database size in bytes
  int get databaseSize => _dbSizeByte;
}

void _debugNote(String s)
{
  debugPrint('DBHelper: $s');
}