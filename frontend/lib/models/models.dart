import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 中で定義するのをやめる。全部引数として渡すようにする
class Model extends ChangeNotifier {
  late List<Note> noteArray;
  late List<List<Problem>> problemArray;
  int mod3 = 0;

  // APIで受けとる
  Model(){
    problemArray = [[Problem(1, ["私","は","ペン","です。"], {"ペン"}), Problem(2, ["Oh"," ","My"," ","God"], {"God"}), 
      Problem(3, ["吾妻鏡","によれば", "1180年","(","治承4年",")","12月12日","に","鎌倉","の","大倉郷","に","頼朝","の","邸","となる","大倉御所","が","置かれ","、",
      "また","幕府","の","統治機構","の","原型","とも","いうべき","侍所","が","設置","されて","武家政権","の","実態","が","形成","された。","朝廷","は","寿永二年十月宣旨",
      "(","1183年",")","で","頼朝","に", "対し、","東国","に","おける","荘園","・","公領","から","の","官物","・","年貢納入","を","保証","させると","同時","に","、","頼朝",
      "に","よる","東国","支配権","を","公認","した","。",],{"吾妻鏡","1180年","治承4年","12月12日","大倉郷","頼朝","大倉御所","侍所","武家政権","朝廷","寿永二年十月宣旨","1183年","公領","支配権"})]];
    
    noteArray = [Note(1, "日本史", problemArray[0], DateTime.now())];
  }

  // ToDo: APIで追加もする
  void addNote(String title){
    var id = 10;
    var createdTime = DateTime.now();
    problemArray.add([]);
    Note newNote = Note(id, title, problemArray[problemArray.length-1], createdTime);
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

  void addProblem(){

  }

  void deleteProblem(){}

  void changeHideWord(noteID){
    mod3 = (mod3+1)%3;

    for (var j = 0; j < problemArray[noteID].length; j++){
      problemArray[noteID][j].isHide = List.generate(problemArray[noteID][j].allWord.length, (k)=>true);
    }

    notifyListeners();
  }

  List<Set<String>> getHideWord(int i, int j){
    return problemArray[i][j].hideWord;
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
  late List<bool> isHide;

  Problem(this.id, this.allWord, this.hideWordCandidate){
    isHide = List.generate(allWord.length, (index) => true);

    int j = 0;
    for (var i = 0; i < allWord.length; i++){
      if (hideWordCandidate.contains(allWord[i]) == false){
        continue;
      }

      hideWord[j%3].add(allWord[i]);
      isHide[i] = true;
      j += 1;
    }
  }
}

class User {
  int id;
  String name;

  User(this.id, this.name);
}