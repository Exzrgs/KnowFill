import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 中で定義するのをやめる。全部引数として渡すようにする
class Model extends ChangeNotifier {
  late List<Note> noteArray;
  late List<List<Problem>> problemArray;

  // APIで受けとる
  Model(){
    problemArray = [[Problem(1, ["私","は","ペン","です"], {"ペン"}), Problem(2, ["Oh","My","God"], {"God"})]];
    noteArray = [Note(1, "日本史", problemArray[0], DateTime.now())];
  }

  // ToDo: APIで追加もする
  void addNote(String title){
    var id = 10;
    var createdTime = DateTime.now();
    Note newNote = Note(id, title, [], createdTime);
    noteArray.add(newNote);
    notifyListeners();
  }

  // データベースからも削除しないといけない
  void deleteNote(index){
    noteArray.removeAt(index);
    notifyListeners();
  }

  // ToDo: APIの送信
  // 作成時間の更新は必要どうか?
  void renameNote(int index, String newName){
    noteArray[index].title = newName;
    notifyListeners();
    return;
  }

  void addProblem(){}

  void deleteProblem(){}

  void changeHideWord(int i, int j){
    var mod3 = getMod3(i, j);
    problemArray[i][j].mod3 = (mod3+1)%3;
    notifyListeners();
    return;
  }

  List<Set<String>> getHideWord(int i, int j){
    return problemArray[i][j].hideWord;
  }

  int getMod3(int i, int j){
    return problemArray[i][j].mod3;
  }

  bool? getIsHide(int i, int j, int k){
    return problemArray[i][j].isHide[k];
  }

  void setIsHide(int i, int j, int k, bool f){
    problemArray[i][j].isHide[k] = f;
    notifyListeners();
  }
}

class Note {
  int id;
  String title;
  List<Problem> problemList;
  DateTime createdTime;

  Note(this.id, this.title, this.problemList, this.createdTime);
}

class Problem {
  int id;
  List<String> allWord;
  Set<String> hideWordCandidate;
  List<Set<String>> hideWord = [{},{},{}];
  int mod3 = 0;
  Map<int, bool> isHide = {};

  Problem(this.id, this.allWord, this.hideWordCandidate){
    int j = 0;
    for (var i = 0; i < allWord.length; i++){
      if (hideWordCandidate.contains(allWord[i]) == false){
        continue;
      }

      hideWord[j%3].add(allWord[i]);
      if (j%3 == 0){
        isHide[i] = true;
      }
      j += 1;
    }
  }
}