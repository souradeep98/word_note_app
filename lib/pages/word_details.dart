import 'package:flutter/material.dart';

import 'package:word_note_app/route_names.dart';

import 'package:word_note_app/structures/word_and_description.dart';

import 'package:word_note_app/utilities/database_helper.dart';

import 'package:word_note_app/widgets/app_bar_title.dart';
import 'package:word_note_app/widgets/centered_view.dart';
import 'package:word_note_app/widgets/snackbar.dart';
import 'package:word_note_app/widgets/word_details_widget.dart';
import 'package:word_note_app/widgets/loading.dart';



class WordDetails extends StatefulWidget
{
  @override
  _WordDetailsState createState() => _WordDetailsState();
}

class _WordDetailsState extends State<WordDetails>
{
  GlobalKey<ScaffoldMessengerState> _wdScaffoldMState = GlobalKey<ScaffoldMessengerState>();
  WordAndDescription _wordAndDescription;
  int _triggerWordID;
  final DBHelper _wordDB = DBHelper();

  Future<bool> _prepare() async
  {
    _debugNote('Called prepare()');
    _wordAndDescription = await _wordDB.readWord(_triggerWordID); //read the word from database
    return true;
  }

  @override
  Widget build(BuildContext context)
  {
    _debugNote('Called build().');
    _triggerWordID = ModalRoute.of(context).settings.arguments; //read the triggering word

    return ScaffoldMessenger(
      key: _wdScaffoldMState,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          centerTitle: true,
          title: AppBarTitle('Word Details'),
          actions: [
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete),
              onPressed: ()
              {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('This will delete the word along with synonyms and descriptions.'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {Navigator.pop(context);},
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () async
                        {
                          await _wordDB.deleteWord(_wordAndDescription.id); //delete the word
                          //Call delete on previous page
                          Navigator.pop(context);
                          Navigator.pop(context, _wordAndDescription.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),



        floatingActionButton: FloatingActionButton.extended(
          label: const Text('Edit'),
          tooltip: 'Edit',
          icon: const Icon(Icons.edit),
          onPressed: () async
          {
            var _res = await Navigator.pushNamed(context, editWordPage, arguments: _wordAndDescription);
            if (_res != null)
            {
              setState(() {});
              showSnack(_wdScaffoldMState, 'Word edited');
            }

          },
        ),



        body: FutureBuilder(
          future: _prepare(),
          builder: (context, snapshot)
          {
            if (snapshot.hasData) return (_wordAndDescription != null) ? ListView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              children: [
                //Word header
                const Text('Word and other synonyms: ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14,),

                //words
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _wordAndDescription.words.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => WordDetailsWidget(_wordAndDescription.words[index]),
                ),

                Divider(color: Colors.grey[500], height: 40,),

                //Descriptions Header
                const Text('Descriptions: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15,),

                //descriptions
                ListView.builder(
                  itemBuilder: (context, index) => DescriptionDetailsWidget(_wordAndDescription.descriptions[index]),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _wordAndDescription.descriptions.length,
                  shrinkWrap: true,
                ),
                const SizedBox(height: 100,),
              ],
            ) : CenteredView(child: const Text('Word unavailable.'));

            else return Loading();
          },
        ),
      ),
    );
  }
}

void _debugNote(String s)
{
  debugPrint('WordDetailsPage: $s');
}
