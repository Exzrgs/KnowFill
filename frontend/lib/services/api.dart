import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/*
実行環境によってURLを変更する必要があるかも
エミュレーター、実機："http://10.0.2.2:8000"
本番："http://127.0.0.1:8000"
*/
const baseURL = "http://10.0.2.2:8000";

Future<void> logIn(String userName, String password) async {
  Uri url = Uri.parse(baseURL + "/api/auth/");
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

Future<void> createUser(String userName, String password) async {
  Uri url = Uri.parse(baseURL + "/api/users/");
  Map<String, String> headers = {'content-type':'application/json'};
  String body = json.encode({'username':userName, 'password':password});
  http.Response res = await http.post(url, headers: headers, body: body);

  var data = json.decode(res.body);

  if (res.statusCode != HttpStatus.created){
    throw data.values;
  }
}