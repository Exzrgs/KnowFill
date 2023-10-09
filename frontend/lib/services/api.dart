import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

const baseURL = "http://127.0.0.1:8000";

// void postAddNote(String title) async {
//   var request = createAddNoteReq(title);
//   var url = Uri.parse(baseURL+"/api/Notelist");
//   var response = await http.post(url,
//     body: request,
//     headers: {"Content-Type": "application/json"},
//   );

//   if (response.statusCode == HttpStatus.accepted){
//     return Note(1, response.title, response.problem, response.updated_at, response.order_num);
//   }
// }

// Map<String, dynamic> createAddNoteReq(String title){
//   return Map<String, dynamic> {
//     'title':title,
//     'problem':[],
//     'order_num':null,
//   };
// }