import 'package:flutter/material.dart';

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
            IconButton(
              icon: const Icon(Icons.add),
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
            ),
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
                    final createdAt = note['createdAt'];
                    final updatedAt = note['updatedAt'];
                    final createdTime = Text(
                      'Created at: $createdAt',
                      // style: const TextStyle(
                      //   fontSize: 12,
                      // ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    );
                    final updatedTime = Text(
                      'Updated at: $updatedAt',
                      // style: const TextStyle(
                      //   fontSize: 12,
                      // ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    );
                    final subTime = updatedAt == '' ? createdTime : updatedTime;
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(note['title']),
                        subtitle: subTime,
                        // Text(
                        //   // date,
                        //   maxLines: 3,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
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
      ),
    );
  }
}
