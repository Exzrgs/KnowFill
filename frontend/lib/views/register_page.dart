import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //ステップ１
  final _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
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
            child: const Text('新規登録'),
            //ステップ２
            onPressed: () async {
              try {
                final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);
                if (newUser != null) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainContent()));
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('指定したメールアドレスは登録済みです'),
                    ),
                  );
                  print('指定したメールアドレスは登録済みです');
                } else if (e.code == 'invalid-email') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('メールアドレスのフォーマットが正しくありません'),
                    ),
                  );
                  print('メールアドレスのフォーマットが正しくありません');
                } else if (e.code == 'operation-not-allowed') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('指定したメールアドレス・パスワードは現在使用できません'),
                    ),
                  );
                  print('指定したメールアドレス・パスワードは現在使用できません');
                } else if (e.code == 'weak-password') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('パスワードは６文字以上にしてください'),
                    ),
                  );
                  print('パスワードは６文字以上にしてください');
                }
              }
            },
          )
        ],
      ),
    );
  }
}