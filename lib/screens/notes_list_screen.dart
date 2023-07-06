import 'package:flutter/material.dart';
import 'package:todo_list_notes_management_v1/widgets/constants.dart';

import '../SQL/sql_helper.dart';
import '../widgets/buttons.dart';
import '../widgets/search_bar.dart';
import 'add_note_screen.dart';
import 'update_note_screen.dart';
import 'package:intl/intl.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _HomePageState();
}

class _HomePageState extends State<NotesListScreen> {
  List<Map<String, dynamic>> notes = [];

  // date is createdAt if updatedAt is null in SQLHelper
  String get timeNow =>
      DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.now());

  // date = createdAt from SQLHelper.getNotes()

  void _refresh() async {
    final data = await SQLHelper.getNotes();
    setState(() {
      notes = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  final TextEditingController _searchController = TextEditingController();

  void _search(String text) async {
    final data = await SQLHelper.searchNotes(text);
    setState(() {
      notes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            actions: [
              // TODO:dropdown menu with 2 options: Add Note and Delete All Notes (SQLHelper.deleteAllNotes())
            ],
          ),
          body: Column(
            children: [
              Search(
                controller: _searchController,
                onChanged: _search,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final desc = note['description'];
                      final createdAt = note['createdAt'];
                      final updatedAt = note['updatedAt'];
                      final descText = Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$desc',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                      final createdTime = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          descText,
                          Text(
                            'Created: $createdAt',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                      final updatedTime = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          descText,
                          Text(
                            'Updated: $updatedAt',
                            style: const TextStyle(
                              color: IosColors.iosWhite,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                      final subTime =
                          updatedAt == '' ? createdTime : updatedTime;
                      return Card(
                        color: Color.fromARGB(255, 48, 48, 48),
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(note['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle: subTime,
                          trailing:
                              DeleteIconButton(note: note, onChanged: _refresh),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditNotesPage(
                                  id: note['id'],
                                  title: note['title'],
                                  description: note['description'] ?? '',
                                  getTimeNow: timeNow,
                                  note: note,
                                  onChanged: _refresh,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: //transparent
                Color.fromARGB(0, 48, 48, 48),
            // hide background
            // Colors.transparent,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNotesPage(
                    getTimeNow: timeNow,
                    buttonState: () {
                      _refresh();
                    },
                    onChanged: _refresh,
                  ),
                ),
              );
            },
            child: const Icon(Icons.edit_square,
                color: Color.fromRGBO(255, 213, 46, 1)),
          )),
    );
  }
}
