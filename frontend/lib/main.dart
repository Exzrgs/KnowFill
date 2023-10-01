import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'ノート一覧'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          final controller = TextEditingController();
          final focusNode = FocusNode();

          showDialog(
            context: context, 
            builder: (_){
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("新しいノートを追加"),
                    Flexible(
                      child: TextFormField(
                        autofocus: true,
                        focusNode: focusNode,
                        controller: controller,
                      ),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    }, 
                    child: const Text("キャンセル")),
                  TextButton(
                    onPressed: (){
                    }, 
                    child: const Text("作成"),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// データベースからも削除しないといけない
void deleteNote(){
  
}

// データベースの名前も変更
void renameNote(){

}

class NoteList extends StatefulWidget {
  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List<String> noteArray = ["日本史","世界史","ミクロ経済学","マクロ経済学","解析学","線形代数学","OS自作入門","p","u","i","u","i","u","i","u","i","u","i","u","i","u","i","u","i","u"];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var name in noteArray) ...{
          ListTile(
            leading: Container(
              width: 100,
            ),
            title: Text(name),
            trailing: GestureDetector(
              child: const Icon(Icons.more_vert),
              onTapDown: (details) {
                final position = details.globalPosition;
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
                  items: <PopupMenuItem<String>>[
                    const PopupMenuItem<String>(
                      value: '名称変更',
                      onTap: renameNote,
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          Text('名称変更'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: '削除',
                      onTap: deleteNote,
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          Text('削除'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => NotePage(title: name),
                  ),
              )
            },
          ),
        }
      ],
    );
  }
}

class NotePage extends StatefulWidget {
  const NotePage({super.key, required this.title});

  final String title;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: NoteDetail(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteDetail extends StatefulWidget {
  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

// ToDo: 右上にメニューを表示
class _NoteDetailState extends State<NoteDetail> {
  List<List<String>> problemArray =  [["私","は","ペン","です"],["Oh","My","God"]];
  List<List<String>> hideList =  [["ペン"],["God"]];
  List<Map<int, bool>> isHide = List.generate(1000, (index) => {index: false});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (var i = 0; i < problemArray.length; i++)...{
        Row(children: [
          for (var j = 0; j < problemArray[i].length; j++)...{
            if (hideList[i].contains(problemArray[i][j]))...{
              if (isHide[i][j] == true)...{
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
                    setState(() {
                      isHide[i][j] = false;
                    })
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
                  child: Text(problemArray[i][j]),
                  onPressed: () => {
                    setState(() {
                      isHide[i][j] = true;
                    })
                  },
                ),
              }
            }
            else...{
              Text(problemArray[i][j]),
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