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
        onPressed: (){},
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
  List<String> noteArray = ["a","i","u","i","u","i","u","i","u","i","u","i","u","i","u","i","u","i","u","i","u","i","u","i","u"];

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
  List<String> problemArray = ["『(?)』によれば(　?　)（(　?　)）(　?　)に鎌倉の(　5　)に(　6　)の邸となる(　7　)が置かれ、また幕府の統治機構の原型ともいうべき(　36　)が設置されて(　18　)の実態が形成された。(　37　)は(　19　)（(　8　)）で(　6　)に 対し、東国における荘園・(　20　)からの官物・年貢納入を保証させると同時に、(　6　)による東国(　21　)を公認した。(　11　)（(　12　)/寿永4年（1185年））で(　23　)を滅ぼし、同年、(　24　)の勅許（(　24　)元年（1185年））では(　6　)へ与えられた諸国への守護・(　26　)の設置・任免を許可した。そして(　14　)（(　15　)）(　6　)が(　27　)大将に任じられ、公卿に列し(　28　)の家政機関たる公文所（(　29　)）開設の権を得たことで、いわば統治機構としての合 法性を帯びるようになり、建久3年（1192年）には(　31　)の宣下がなされた。こうして、名実ともに(　18　)として成立することとなった。守護の設置で幕府は諸国の治安維持を担当したものの、当初はその支配は限定的だったが、次第に範囲 を拡大。(　17　)や元寇を経て、全国的な(　21　)を確立するに至った。r","i"];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: problemArray.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 20,
                ),
                title: Text(problemArray[index],
                style: const TextStyle(
                  fontSize: 15,
                  letterSpacing: 1,
                ),),
                trailing: const Icon(Icons.more_vert),
              ),
              const Divider(
                color: Colors.black,
              ),
            ]
          );
        },
      );
  }
}