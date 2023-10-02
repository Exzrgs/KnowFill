import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class NoteDetail extends StatefulWidget {
  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

// ToDo: 右上にメニューを表示
class _NoteDetailState extends State<NoteDetail> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);

    return Column(children: [
      for (var i = 0; i < model.noteArray.length; i++)...{
        Row(children: [
          for (var j = 0; j < model.noteArray[i].problemList.length; j++)...{
            for (var k = 0; k < model.problemArray[i][j].allWord.length; k++)...{
              if (model.problemArray[i][j].hideWordCandidate.contains(model.problemArray[i][j].allWord[k]))...{
                if (model.problemArray[i][j].isHide[k] == true)...{
                  // Container(
                  //   margin: const EdgeInsets.all(10.0), // 外側余白
                  //   //padding: const EdgeInsets.all(10.0), // 内側余白
                  //   color: Colors.grey,
                  //   width: 60, // 画面サイズいっぱいまで広げる
                  //   height: 30.0,
                  //   alignment: Alignment.center,

                  //   child: IconButton(
                  //     icon: const Icon(Icons.visibility),
                  //     onPressed: (){
                  //       setState(() {
                  //         isHide[i][j] = false;
                  //       });
                  //     },
                  //   ),
                  // ),

                  TextButton(
                    child: const Text("( ? )"),
                    onPressed: () => {
                      model.setIsHide(i, j, k, false)
                    },
                  )
                }
                else ...{
                  // IconButton(
                  //   icon: const Icon(Icons.visibility_off),
                  //   onPressed: (){
                  //     setState(() {
                  //       isHide[i][j] = true;
                  //     });
                  //   },
                  // ),
                  TextButton(
                    child: Text(model.noteArray[i].problemList[j].allWord[k]),
                    onPressed: () => {
                      setState(() {
                        model.setIsHide(i, j, k, true);
                      })
                    },
                  ),
                }
              }
              else...{
                Text(model.problemArray[i][j].allWord[k]),
              }
            }
          },
          const Divider(
            color: Colors.black,
          ),
        ],)
      }
    ]);
  }
}