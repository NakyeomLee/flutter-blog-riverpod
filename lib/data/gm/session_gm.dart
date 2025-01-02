import 'package:flutter/cupertino.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin});
}

class SessionGM extends Notifier<SessionUser>{

  // TODO 2: 모름
  final mContext = navigatorKey.currentContext!;

  @override
  SessionUser build() {
    return SessionUser(id: null, username: null, accessToken: null, isLogin: false);
  }

  Future<void> login() async {}

  Future<void> join() async {}

  Future<void> logout() async {}

  Future<void> autoLogin() async {
    Future.delayed(
      Duration(seconds: 3), // 3초 딜레이
          () {
        Navigator.popAndPushNamed(mContext, "/login"); // 실행하자마자 나올 화면
      },
    );
  }

}

final sessionProvider = NotifierProvider<SessionGM, SessionUser>(() {
  return SessionGM();
});