import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:takuma_sample/sign_up.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  _UserLogin createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  final _auth = FirebaseAuth.instance;

  String email = '';
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
                email = value;
              },
              decoration: const InputDecoration(
                hintText: 'メールアドレスを入力',
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
                final newUser = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (newUser != null) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainContent()));
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-email') {
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
                }
              }
            },
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Register()));
              },
              child: Text('新規登録はこちらから'))
        ],
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  //ステップ１
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('成功'),
        actions: [
          IconButton(
            //ステップ２
            onPressed: () async {
              await _auth.signOut();
              if (_auth.currentUser == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ログアウトしました'),
                  ),
                );
                print('ログアウトしました！');
              }
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