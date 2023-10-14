

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../views/home_page.dart';
import '../views/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLogin = false;

    return FutureBuilder<String?>(
      future: getToken(),
      builder: (context, snapshot) {
        var token = snapshot.data;
        if (token == null){
          isLogin = false;
        } else {
          isLogin = true;
        }

        return ChangeNotifierProvider<Model>(
          create: (context) => Model(),
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: isLogin ? const HomePage(title: 'ノート一覧') : const UserLogin()
          ),
        );
      }
    );
  }
  Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    var token = await storage.read(key: 'knowfill-token');
    return token;
  }
}