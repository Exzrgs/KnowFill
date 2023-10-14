import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

final imagePicker = ImagePicker();

// カメラから写真を取得するメソッド
Future<String> getImageFromCamera() async {
  final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
  XFile? image;
  if (pickedFile != null) {
    image = XFile(pickedFile.path);
  }
  List<int>? imageBytes = await image?.readAsBytes();
  if (imageBytes == null) {
    throw Exception("Failed to read image bytes");
  }
  String base64image = base64Encode(imageBytes);
  return base64image;
}

// ギャラリーから写真を取得するメソッド
Future<String> getImageFromGarally() async {
  final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  XFile? image;
  if (pickedFile != null) {
    image = XFile(pickedFile.path);
  }
  List<int>? imageBytes = await image?.readAsBytes();
  if (imageBytes == null) {
    throw Exception("Failed to read image bytes");
  }
  String base64image = base64Encode(imageBytes);
  return base64image;
}