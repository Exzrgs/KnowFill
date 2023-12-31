import 'package:flutter/material.dart';
import 'package:frontend/views/note_detail_page.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';

class NoteDetail extends StatefulWidget {
  final int noteID;
  const NoteDetail({super.key, required this.noteID});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<Model>();

    List<Problem> problemArray = model.noteArray[widget.noteID].problemList;

    return ListView(
      children: [
        Column(
            children: [
              for (var j = 0; j < problemArray.length; j++)...{
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Wrap(
                    runSpacing: 10,
                    children: [
                      for (var k = 0; k < problemArray[j].allWord.length; k++)...{
                        if (problemArray[j].hideWord[model.mod3].contains(problemArray[j].allWord[k]))...{
                          if (problemArray[j].isHide[k] == true)...{
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
                                  padding: MaterialStateProperty.all(EdgeInsets.zero),
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
                          Text(problemArray[j].allWord[k]),
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
          ],)
        ],
      );
    }
  }