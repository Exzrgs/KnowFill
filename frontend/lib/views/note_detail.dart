import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class NoteDetail extends StatefulWidget {
  final int noteID;
  const NoteDetail({super.key, required this.noteID});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

// ToDo: 右上にメニューを表示
// ToDo: NoteDetailは個別のものだから、インデックスを引数にとって表示しないといけない
class _NoteDetailState extends State<NoteDetail> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<Model>(context);
    model.init();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Container(
        width: 400,
        child: Column(children: [
            for (var j = 0; j < model.problemArray[widget.noteID].length; j++)...{
              Wrap(children: [
                  for (var k = 0; k < model.problemArray[widget.noteID][j].allWord.length; k++)...{
                    if (model.noteArray[widget.noteID].problemList[j].hideWord[model.mod3].contains(model.problemArray[widget.noteID][j].allWord[k]))...{
                      if (model.problemArray[widget.noteID][j].isHide[k] == true)...{
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
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),  // パディングを0に設定
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,  // タップ領域をコンテンツの大きさに合わせる
                            minimumSize: MaterialStateProperty.all(Size.zero),
                          ),
                          child: const Text("( ? )"),
                          onPressed: () => {
                            model.setIsHide(widget.noteID, j, k, false)
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
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),  // パディングを0に設定
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,  // タップ領域をコンテンツの大きさに合わせる
                            minimumSize: MaterialStateProperty.all(Size.zero)
                          ),
                          child: Text(model.noteArray[widget.noteID].problemList[j].allWord[k]),
                          onPressed: () => {
                            setState(() {
                              model.setIsHide(widget.noteID, j, k, true);
                            })
                          },
                        ),
                      }
                    }
                    else...{
                      Text(model.problemArray[widget.noteID][j].allWord[k]),
                    }
                  }
                ]),
              const Divider(
                color: Colors.black,
              ),
            }
          ],)
        ),
      ],);
    }
  }