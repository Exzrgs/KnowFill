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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){
              getImageFromGarally();
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

  XFile? _image;
  final imagePicker = ImagePicker();

  // カメラから写真を取得するメソッド
  Future getImageFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }

  // ギャラリーから写真を取得するメソッド
  Future getImageFromGarally() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }
}