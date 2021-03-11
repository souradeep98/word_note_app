import 'package:flutter/material.dart';
import 'package:word_note_app/structures/word_and_description.dart';
import 'package:word_note_app/utilities/database_helper.dart';
import 'package:word_note_app/widgets/centered_view.dart';
import 'package:word_note_app/widgets/loading.dart';
import 'package:word_note_app/widgets/popup_view.dart';
import 'package:word_note_app/widgets/word_details_widget.dart';

class QuickLookup extends StatefulWidget
{
  final id;
  QuickLookup(this.id);

  @override
  _QuickLookupState createState() => _QuickLookupState();
}

class _QuickLookupState extends State<QuickLookup>
{
  WordAndDescription _wordAndDescription;

  final DBHelper _dbHelper = DBHelper();



  Future<bool> _prepare() async
  {
    _wordAndDescription = await _dbHelper.readWord(widget.id);
    return true;
  }

  @override
  Widget build(BuildContext context)
  {
    return PopupView(
      title: 'Quick Lookup',
      child: FutureBuilder(
        future: _prepare(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
          {
            return (_wordAndDescription != null) ? ListView( //Words and Descriptions
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              children: [
                //Word header
                const Text('Word and other synonyms: ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14,),

                //Words
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _wordAndDescription.words.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => WordDetailsWidget(_wordAndDescription.words[index]),
                ),

                const Divider(height: 40,),

                //Descriptions Header
                const Text('Descriptions: ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14,),

                //Descriptions
                ListView.builder(
                  itemBuilder: (context, index) => DescriptionDetailsWidget(_wordAndDescription.descriptions[index]),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _wordAndDescription.descriptions.length,
                  shrinkWrap: true,
                ),
                const SizedBox(height: 20,),
              ],
            ) : CenteredView(
              child: const Text('Word unavailable.'),
            );
          }
          return Loading();
        },
      )
    );

  }
}
