import 'package:flutter/material.dart';
import 'package:sqlflite_note_app/models/note.dart';

class AddEditNotePage extends StatefulWidget {
  const AddEditNotePage({Key? key,required this.note}) : super(key: key);
  final Note? note;

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  void addOrUpdateNote(){
    
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
