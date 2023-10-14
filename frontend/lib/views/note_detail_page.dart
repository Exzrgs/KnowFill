import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import './note_detail.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/function.dart';

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
    model.init();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[300],
        title: Text(model.noteArray[widget.noteID].title),
      ),
      body: NoteDetail(noteID: widget.noteID),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              String imageData = await getImageFromGarally();
              model.addProblem(widget.noteID, imageData);
            },
            tooltip: 'Adding',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: (){
              model.changeHideWord(widget.noteID);
            },
            tooltip: 'Changing',
            child: const Icon(Icons.sync),
          )
        ],
      )
    );
  }
}