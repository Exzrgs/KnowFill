import 'package:flutter/material.dart';
import './note_detail.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import 'package:image_picker/image_picker.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key, required this.noteID});

  final int noteID;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(model.noteArray[widget.noteID].title),
      ),
      body: NoteDetail(noteID: widget.noteID),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}