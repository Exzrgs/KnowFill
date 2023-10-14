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

    return Column(
        children: [
          for (var j = 0; j < model.problemArray[widget.noteID].length; j++)...{
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Wrap(
                runSpacing: 10,
                children: [
                  for (var k = 0; k < model.problemArray[widget.noteID][j].allWord.length; k++)...{
                    if (model.noteArray[widget.noteID].problemList[j].hideWord[model.mod3].contains(model.problemArray[widget.noteID][j].allWord[k]))...{
                      if (model.problemArray[widget.noteID][j].isHide[k] == true)...{
                        Container(
                          width: 50,
                          height: 20,
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.zero),  // パディングを0に設定
                            ),
                            child: const Text('?',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: (){
                              model.setIsHide(widget.noteID, j, k, false);
                            },
                          ),
                        ),
                      }
                      else ...{
                        TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),  // パディングを0に設定
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,  // タップ領域をコンテンツの大きさに合わせる
                            minimumSize: MaterialStateProperty.all(Size.zero)
                          ),
                          child: Text(model.noteArray[widget.noteID].problemList[j].allWord[k],
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
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
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.blueAccent,
              thickness: 1,
            ),
        }
      ],);
    }
  }