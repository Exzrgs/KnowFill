import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Model extends ChangeNotifier {
  List<Note> noteArray = [];
  int mod3 = 0;

  Model() {
    Future(() async {
      await init();
      notifyListeners();
    });
    // var problemArray = [[Problem(1, ["私","は","ペン","です。"], {"ペン"}), Problem(2, ["Oh"," ","My"," ","God"], {"God"}), 
    //   Problem(3, ["吾妻鏡","によれば", "1180年","(","治承4年",")","12月12日","に","鎌倉","の","大倉郷","に","頼朝","の","邸","となる","大倉御所","が","置かれ","、",
    //   "また","幕府","の","統治機構","の","原型","とも","いうべき","侍所","が","設置","されて","武家政権","の","実態","が","形成","された。","朝廷","は","寿永二年十月宣旨",
    //   "(","1183年",")","で","頼朝","に", "対し、","東国","に","おける","荘園","・","公領","から","の","官物","・","年貢納入","を","保証","させると","同時","に","、","頼朝",
    //   "に","よる","東国","支配権","を","公認","した","。",],{"吾妻鏡","1180年","治承4年","12月12日","大倉郷","頼朝","大倉御所","侍所","武家政権","朝廷","寿永二年十月宣旨","1183年","公領","支配権"})]];
    
    // noteArray = [Note(1, "日本史", problemArray[0])];
  }

  init() async {
    var noteList = await getNoteList();
    for (var i=0; i<noteList.length; i++) {
      List<Problem> problemList = [];
      for (var j=0; j<noteList[i]["problem"].length; j++){
        int id = noteList[i]["problem"][j]["id"];

        List<dynamic> dynamicList = noteList[i]["problem"][j]["mondaibun_list"];
        List<String> mondaibunList = dynamicList.map((item) => item.toString()).toList();

        dynamicList = noteList[i]["problem"][j]["ana"];
        Set<String> ana = dynamicList.map((item) => item.toString()).toSet();
        
        Problem newProblem = Problem(id, mondaibunList, ana);
        problemList.add(newProblem);
      }

      Note newNote = Note(noteList[i]["id"], noteList[i]["title"], problemList);
      noteArray.add(newNote);
    }
  }

  /*
  実行環境によってURLを変更する必要があるかも
  エミュレーター、実機："http://10.0.2.2:8000"
  本番："http://127.0.0.1:8000"
  */
  String baseURL = "http://10.0.2.2:8000";
  final storage = const FlutterSecureStorage();

  Future<Map<String, String>> makeHeader() async {
    var token = await storage.read(key: 'knowfill-token');
    Map<String, String> headers = {'content-type':'application/json', 'Authorization':'Token $token'};
    return headers;
  }

  Future getNoteList() async {
    Uri url = Uri.parse(baseURL+"/api/Notelist/");
    var headers = await makeHeader();
    var res = await http.get(url, headers: headers);

    // List<Map<String, dynamic>>
    var data = json.decode(res.body);
    return data;
  }

  void addNote(String title) async {
    Uri url = Uri.parse(baseURL+"/api/Notelist/");
    var headers = await makeHeader();
    String body = json.encode({'title': title, 'problem': []});
    var res = await http.post(url, headers: headers, body: body);

    var data = json.decode(res.body);
    print(data);

    Note newNote = Note(data["note_id"], title, []);
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

  // APIで画像データを送って、allwordを受け取る
  Future addProblem(int note_id, String imageData) async {
    Uri url = Uri.parse(baseURL+"/api/problem/");
    var headers = await makeHeader();
    String body = json.encode({'problem_image': imageData, 'note_id': note_id, 'order_num': null});
    var res = await http.post(url, headers: headers, body: body);

    var getList = json.decode(res.body);

    List<Problem> problemArray = [];

    for (var i=0; i<getList["mondaibun_list"].length; i++){
      var problem = Problem(getList["id"], getList["mondaibun_list"], getList["ana"]);
      problemArray.add(problem);
    }

    noteArray[note_id].problemList = problemArray;

    notifyListeners();
  }

  void deleteProblem(){}

  void changeHideWord(noteID){
    mod3 = (mod3+1)%3;

    List<Problem> problemArray = noteArray[noteID].problemList;

    for (var j = 0; j < problemArray.length; j++){
      problemArray[j].isHide = List.generate(problemArray[j].allWord.length, (k)=>true);
    }

    notifyListeners();
  }

  List<Set<String>> getHideWord(int i, int j){
    List<Problem> problemArray = noteArray[i].problemList;
    return problemArray[j].hideWord;
  }

  bool? getIsHide(int i, int j, int k){
    List<Problem> problemArray = noteArray[i].problemList;
    return problemArray[j].isHide[k];
  }

  void setIsHide(int i, int j, int k, bool f){
    List<Problem> problemArray = noteArray[i].problemList;
    problemArray[j].isHide[k] = f;
    notifyListeners();
  }
}

class Note {
  int id;
  String title;
  List<Problem> problemList;

  Note(this.id, this.title, this.problemList);
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