import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlflite_note_app/db/notes_database.dart';
import 'package:sqlflite_note_app/models/note.dart';
import 'package:sqlflite_note_app/page/add_edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);
  int noteId;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  /// Next few lines is actually state
  late Note note;
  bool isLoading = false;
  @override
  void initState() {
    refreshNote();
    super.initState();
  }

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Note Details'),
          actions: [
            deleteButton(),
          ],
        ),
        body: isLoading
            ? const CircularProgressIndicator()
            : ListView(
                children: [
                  Text(note.title),
                  Text(DateFormat.yMMMd().format(note.createdTime)),
                  Text(note.description)
                ],
              ));
  }

  Widget deleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () async {
        await NotesDatabase.instance.deleteNote(widget.noteId);
        Navigator.of(context).pop();
      },
    );
  }

  Widget editButton() {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () async {
       await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddEditNotePage(
                        note: note,
                      )));
      },
    );
  }
}
