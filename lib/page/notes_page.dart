import 'package:flutter/material.dart';
import 'package:sqlflite_note_app/db/notes_database.dart';
import 'package:sqlflite_note_app/models/note.dart';
import '';

class NotesPage extends StatefulWidget {
  NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;
  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
