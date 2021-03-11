import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:word_note_app/constants.dart';
import 'package:word_note_app/route_names.dart';

import 'package:word_note_app/pages/home.dart';
import 'package:word_note_app/pages/add_word.dart';
import 'package:word_note_app/pages/word_details.dart';
import 'package:word_note_app/pages/edit_word.dart';
import 'package:word_note_app/pages/splash.dart';
import 'package:word_note_app/pages/word_database_manager.dart';

import 'package:word_note_app/utilities/search_filter.dart';
import 'package:word_note_app/utilities/word_manager.dart';

import 'package:word_note_app/about/about_page.dart';


void main()
{
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => WordManager()),
      ChangeNotifierProvider(create: (context) => SearchFilter()),
    ],
    child: WordNote(),
  ));
}

class WordNote extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Note',
      initialRoute: splashPage,
      routes: {
        splashPage: (context) => Splash(),
        homePage: (context) => Home(),
        addWordPage: (context) => AddWord(),
        wordDetailsPage: (context) => WordDetails(),
        editWordPage: (context) => EditWord(),
        wordDatabaseManagerPage: (context) => WordDatabaseManager(),
        aboutPage: (context) => About(),
      },

      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: lightModePrimaryColor,
        accentColor: lightModeAccentColor,
        cardColor: lightModeCardColor,
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: lightModeAccentColor,
          selectionColor: lightModeTextSelectionColor,
          cursorColor: lightModeAccentColor,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        cardColor: darkModeCardColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: darkModePrimaryColor),
        dialogBackgroundColor: darkModeScaffoldBackgroundColor,
        popupMenuTheme: PopupMenuThemeData(color: darkModePopupMenuBackgroundColor),
        primaryColor: darkModePrimaryColor,
        accentColor: darkModeAccentColor,
        scaffoldBackgroundColor: darkModeScaffoldBackgroundColor,
        errorColor: darkModeErrorColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: darkModeCursorColor,
          selectionHandleColor: darkModeCursorColor,
        ),

      ),

      themeMode: ThemeMode.system,
    );
  }
}


