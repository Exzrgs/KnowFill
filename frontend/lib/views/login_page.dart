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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
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

    var data = json.decode(res.body);
    if (res.statusCode != HttpStatus.ok){
      throw data.values;
    }

    const storage = FlutterSecureStorage();
    await storage.write(key: 'knowfill-token', value: data["token"]);
    return;
  }
}