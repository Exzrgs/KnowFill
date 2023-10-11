import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import './note_detail.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_functions/cloud_functions.dart';

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
              model.addProblem(imageData);
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

  final imagePicker = ImagePicker();

  // カメラから写真を取得するメソッド
  Future<String> getImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    XFile? image;
    if (pickedFile != null) {
      image = XFile(pickedFile.path);
    }
    List<int>? imageBytes = await image?.readAsBytes();
    if (imageBytes == null) {
      throw Exception("Failed to read image bytes");
    }
    String base64image = base64Encode(imageBytes);
    return base64image;
  }

  // ギャラリーから写真を取得するメソッド
  Future<String> getImageFromGarally() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    XFile? image;
    if (pickedFile != null) {
      image = XFile(pickedFile.path);
    }
    List<int>? imageBytes = await image?.readAsBytes();
    if (imageBytes == null) {
      throw Exception("Failed to read image bytes");
    }
    String base64image = base64Encode(imageBytes);
    return base64image;
  }
}