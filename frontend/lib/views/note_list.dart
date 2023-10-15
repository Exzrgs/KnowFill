import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:provider/provider.dart';
import './note_detail_page.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({Key? key}) : super(key: key);

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);

    return Container(
    width: 390,
    margin: const EdgeInsets.only(top: 10, left: 10),
    child: ListView.separated(
      itemCount: model.noteArray.length,
      itemBuilder: (context, index){
        return ListTile(
          tileColor: Colors.lightBlue[100],
          minVerticalPadding: 4.0,
          leading: Container(
            width: 2,
          ),
          title: Text(model.noteArray[index].title),
          subtitle: Text("${model.noteArray[index].updateTime.year}年${model.noteArray[index].updateTime.month}月${model.noteArray[index].updateTime.day}日"),
          trailing: GestureDetector(
            child: const Icon(Icons.more_vert),
            onTapDown: (details) {
              final position = details.globalPosition;
              renameDeleteMenu(context, position, model, index);
            },
          ),
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => NotePage(noteID: index),
                ),
              )
            }
          );
        },
        separatorBuilder: (context, index){
          return const Divider(
            height: 10,
            color: Colors.transparent,
          );
        },
    ),
    );
  }

  void renameDeleteMenu(context, position, model, index){
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
      items: <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: '名称変更',
          onTap: () => renameNoteDialog(context, model, index),
          child: const Row(
            children: [
              Icon(Icons.edit),
              Text('名称変更'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '削除',
          onTap: () async => await model.deleteNote(index),
          child: const Row(
            children: [
              Icon(Icons.delete),
              Text('削除'),
            ],
          ),
        ),
      ],
    );
  }

  void renameNoteDialog(context, model, index){
    final controller = TextEditingController();
    final focusNode = FocusNode();

    showDialog(
      context: context, 
      builder: (BuildContext dialogContext){
        String taskName = "";
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("名称を変更"),
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
                await model.renameNote(index, taskName);
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