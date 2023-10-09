import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import './login_page.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../main.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //ステップ１
  String userName = '';
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
            child: const Text('新規登録'),
            //ステップ２
            onPressed: () async {
              try {
                await createUser(userName, password);
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => App()));
              } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
              }
            },
          )
        ],
      ),
    );
  }

  String baseURL = "http://127.0.0.1:8000";
  String emulater_baseURL = "http://10.0.2.2:8000";

  Future<void> createUser(String userName, String password) async {
    Uri url = Uri.parse(emulater_baseURL + "/api/users/");
    Map<String, String> headers = {'content-type':'application/json'};
    String body = json.encode({'username':userName, 'password':password});
    http.Response res = await http.post(url, headers: headers, body: body);

    var data = json.decode(res.body);

    if (res.statusCode != HttpStatus.accepted){
      throw data.values;
    }
  }
}