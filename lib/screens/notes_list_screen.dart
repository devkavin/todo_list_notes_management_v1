import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/constants.dart';

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

  // date time
  String get timeNow => DateFormat('yyyy-MM-dd').format(DateTime.now());
  // String get dateNow => DateFormat('yyyy-MM-dd').format(DateTime.now());
  // String get timeNow => DateFormat('HH:mm a').format(DateTime.now());

  // date = createdAt from SQLHelper.getNotes()

  void _refresh() async {
    final data = await SQLHelper.getNotes();
    // final data = await SQLHelper.getNotesLatestFirst();
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
            title: const Text(
              'Notes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                      // sort by latest first by date and time
                      final desc = note['description'];
                      final createdAt = note['createdAt'];
                      // final updatedAt = note['updatedAt'];

                      final subText = Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                        child: Row(
                          children: [
                            Text(
                              '$createdAt',
                              style: const TextStyle(
                                color: IosColors.iosLightGrey,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                              child: Text(
                                '$desc',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );

                      return Card(
                        color: IosColors.iosGrey,
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(note['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle:
                              // subTime,
                              subText,
                          trailing:
                              DeleteIconButton(note: note, onChanged: _refresh),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              CupertinoPageRoute(
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
                const Color.fromARGB(0, 48, 48, 48),
            // hide background
            // Colors.transparent,
            onPressed: () async {
              await Navigator.push(
                context,
                CupertinoPageRoute(
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
            child: const Icon(Icons.edit_square, color: IosColors.iosYellow),
          )),
    );
  }
}
