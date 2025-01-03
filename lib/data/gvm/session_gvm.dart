import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// 로그인 화면이나 회원가입 화면처럼 데이터를 미리 뿌려놓을 필요가 없는 화면은
// ViewModel이 없고, GlobalViewModel에 붙으면 됨

class SessionUser {
  int? id;
  String? username;
  String? accessToken;
  bool? isLogin;

  SessionUser({this.id, this.username, this.accessToken, this.isLogin = false});
}

class SessionGVM extends Notifier<SessionUser>{

  // TODO 2: 모름
  final mContext = navigatorKey.currentContext!; // null일수도 있어서 ! 붙임 / mContext가 Stack에서 최상단 context
  UserRepository userRepository = const UserRepository(); // const가 있어야 싱글턴으로 관리됨 주의

  @override
  SessionUser build() {
    return SessionUser(id: null, username: null, accessToken: null, isLogin: false);
  }

  // 로그인
  // async 함수이니까 void여도 Future 붙여야됨(문법이니까 외우기)
  Future<void> login(String username, String password) async {

    final requestBody = {
      "username":username,
      "password":password,
    };

    final (responseBody, accessToken) = await userRepository.findByUsernameAndPassword(requestBody);
    
    if (!responseBody["success"]) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
        SnackBar(content: Text("로그인 실패 : ${responseBody["errorMessage"]}")),
      );
      return; // return에 값 안 적으면 메서드 그냥 종료되는것 (값 있으면 그 값 반환되는거고)
    }

    // 1. 토큰을 Storage에 저장
    await secureStorage.write(key: "accessToken", value: accessToken); // I/O (내부에 비동기 걸려있음 => 오래걸리니까 await)

    // 2. SessionUser 갱신
    Map<String, dynamic> data = responseBody["response"];
    state = SessionUser(id: data["id"], username: data["username"], accessToken: accessToken, isLogin: true);
    
    // 3. Dio에 토큰 세팅
    // dio는 메모리에 저장하는거니까 await 안 걸어도됨
    dio.options.headers = {
      "Authorization": accessToken
    };

    // Logger().d(dio.options.headers);
    
    // 페이지 이동
    // popAndPushNamed : 화면 날리기 => 이 경우 로그인 화면을 날리고 게시물 리스트 화면으로 이동
    Navigator.popAndPushNamed(mContext, "/post/list");
  }

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
      return; // return에 값 안 적으면 메서드 그냥 종료되는것 (값 있으면 그 값 반환되는거고)
    }

    // 회원가입 success일 경우(정상) => 로그인 화면으로 이동
    Navigator.pushNamed(mContext, "/login");
  }

  Future<void> logout() async {
    // 1. 디바이스 토큰 삭제
    await secureStorage.delete(key: "accessToken"); // I/O (내부에 비동기 걸려있음 => 오래걸리니까 await)
    
    // 2. 상태 갱신
    state = SessionUser();

    // 3. 화면 이동
    // 로그아웃 화면 날리고 로그인 화면으로 이동
    Navigator.popAndPushNamed(mContext, "/login");
  }

  // 자동 로그인
  // 1. 절대 SessionUser가 있을 수 없음
  Future<void> autoLogin() async {
    // 1. 토큰 디바이스에서 가져오기
    String? accessToken = await secureStorage.read(key: "accessToken"); // 오래 걸리니까 await
    
    if (accessToken == null) {
      Navigator.popAndPushNamed(mContext, "/login");
      return;
    }

    // 책임 위임
    Map<String, dynamic> responseBody = await userRepository.autoLogin(accessToken);
    
    if (!responseBody["success"]) {
      Navigator.popAndPushNamed(mContext, "/login");
      return;
    }

    // 상태 갱신 (SessionUser 갱신)
    Map<String, dynamic> data = responseBody["response"];
    state = SessionUser(id: data["id"], username: data["username"], accessToken: accessToken, isLogin: true);

    dio.options.headers = {"Authorization": accessToken};
    
    // 화면 날리고 게시물 리스트 화면으로 이동 (자동 로그인이라 앱 실행하자마자 게시물 리스트 화면부터 나올것)
    Navigator.popAndPushNamed(mContext, "/post/list");
  }
}

final sessionProvider = NotifierProvider<SessionGVM, SessionUser>(() {
  return SessionGVM();
});