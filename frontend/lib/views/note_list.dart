import 'package:flutter/material.dart';
import 'package:frontend/models/models.dart';
import 'package:provider/provider.dart';
import './note_detail.dart';
import './note_detail_page.dart';

class NoteListView extends StatefulWidget {
  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);

    return Container(
    width: 390,
    margin: const EdgeInsets.only(top: 10, left: 10), // 上から50px、左から20pxの位置に配置
    child: ListView.separated(
      itemCount: model.noteArray.length,
      itemBuilder: (context, index){
        return ListTile(
          tileColor: Colors.lightBlue[100],
          //contentPadding: const EdgeInsets.all(10),
          minVerticalPadding: 4.0,
          // shape: const RoundedRectangleBorder(
          // borderRadius: BorderRadius.all(Radius.circular(100)),
          // ),
          leading: Container(
            width: 2,
          ),
          title: Text(model.noteArray[index].title),
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

  void renameDeleteMenu(BuildContext context, position, model, index){
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
      items: <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: '名称変更',
          onTap: () => model.renameNote(index, "a"),
          child: const Row(
            children: [
              Icon(Icons.edit),
              Text('名称変更'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: '削除',
          onTap: () => model.deleteNote(index),
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
}