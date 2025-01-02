import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 로그인 화면이나 회원가입 화면처럼 데이터를 미리 뿌려놓을 필요가 없는 화면은
// ViewModel이 없고, GlobalViewModel에 붙으면 됨

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin});
}

class SessionGVM extends Notifier<SessionUser>{

  // TODO 2: 모름
  final mContext = navigatorKey.currentContext!; // null일수도 있어서 ! 붙임 / mContext가 Stack에서 최상단 context
  UserRepository userRepository = const UserRepository(); // const가 있어야 싱글턴으로 관리됨 주의

  @override
  SessionUser build() {
    return SessionUser(id: null, username: null, accessToken: null, isLogin: false);
  }

  Future<void> login() async {}

  Future<void> join(String username, String email, String password) async {

    // repository에 요청
    final requestBody = {
      "username":username,
      "email":email,
      "password":password,
    };

    Map<String, dynamic> responseBody = await userRepository.save(requestBody);
    // 회원가입 success가 아닌 경우(비정상) => 회원가입 실패 에러메세지 적힌 스낵바 띄우기 
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("회원가입 실패 : ${responseBody["errorMessage"]}")),
      );
    }

    // 회원가입 success일 경우(정상) => 로그인 화면으로 이동
    Navigator.pushNamed(mContext, "/login");
  }

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

final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(() {
  return SessionGVM();
});