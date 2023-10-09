import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/views/home_page.dart';
import '../models/models.dart';
import './register_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  _UserLogin createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  String userName = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                userName = value;
              },
              decoration: const InputDecoration(
                hintText: 'ユーザー名を入力',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'パスワードを入力',
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('ログイン'),
            onPressed: () async {
              try {
                await logIn(userName, password);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => App()));
              } catch (e) {
                print(e);
                /*if (e.code == 'invalid-email') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(''),
                    ),
                  );
                  print('メールアドレスのフォーマットが正しくありません');
                } else if (e.code == 'user-disabled') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('現在指定したメールアドレスは使用できません'),
                    ),
                  );
                  print('現在指定したメールアドレスは使用できません');
                } else if (e.code == 'user-not-found') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('指定したメールアドレスは登録されていません'),
                    ),
                  );
                  print('指定したメールアドレスは登録されていません');
                } else if (e.code == 'wrong-password') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('パスワードが間違っています'),
                    ),
                  );
                  print('パスワードが間違っています');
                }*/
              }
            },
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: const Text('新規登録はこちらから'))
        ],
      ),
    );
  }

  String baseURL = "http://127.0.0.1:8000";
  String emulater_baseURL = "http://10.0.2.2:8000";

  Future<void> logIn(String userName, String password) async {
    Uri url = Uri.parse(emulater_baseURL + "/api/auth/");
    Map<String, String> headers = {'content-type':'application/json'};
    String body = json.encode({'username':userName, 'password':password});
    http.Response res = await http.post(url, headers: headers, body: body);

    // if (res.statusCode == HttpStatus.accepted){
    //   throw CustomException('username-already-in-use', res.body);
    // }

    var data = json.decode(res.body);
    const storage = FlutterSecureStorage();
    await storage.write(key: 'knowfill-token', value: data["token"]);
    return;
  }
}

class MainContent extends StatefulWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  //ステップ１

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('成功'),
        actions: [
          IconButton(
            //ステップ２
            onPressed: () async {
              /*await _auth.signOut();
              if (_auth.currentUser == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ログアウトしました'),
                  ),
                );
                print('ログアウトしました！');
              }
              */
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserLogin()));
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: Center(
        child: Text('ログイン成功！'),
      ),
    );
  }
}