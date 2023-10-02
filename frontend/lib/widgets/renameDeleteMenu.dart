import 'package:flutter/material.dart';

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