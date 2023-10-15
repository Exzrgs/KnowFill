import 'package:flutter/material.dart';
import './note_list.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[300],
        title: Text(widget.title),
      ),
      body: const NoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addNoteDialog(model);
        },
        tooltip: 'AddNote',
        child: const Icon(Icons.add),
      ),
    );
  }

  void addNoteDialog(model){
    final controller = TextEditingController();
    final focusNode = FocusNode();

    showDialog (
      context: context, 
      builder: (BuildContext dialogContext){
        String taskName = "";
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("新しいノートを追加"),
              Flexible(
                child: TextFormField(
                  autofocus: true,
                  focusNode: focusNode,
                  controller: controller,
                  onChanged: (value) => {
                    taskName = value
                  },
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(dialogContext).pop();
              }, 
              child: const Text("キャンセル")),
            TextButton(
              onPressed: () async {
                if (taskName == ""){
                  return;
                }
                await model.addNote(taskName);
                Navigator.of(dialogContext).pop();
              },
              child: const Text("作成"),
            ),
          ],
        );
      },
    );
  }
}