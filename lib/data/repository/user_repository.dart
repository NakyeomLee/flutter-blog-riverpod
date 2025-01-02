import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/utils/my_http.dart';
import 'package:logger/logger.dart';

class UserRepository {
  const UserRepository();

  // join(회원가입)
  // Map으로 받는 이유? : 사용자가 입력하는 데이터를 Map으로 묶어서 넘길꺼니까
  Future<Map<String, dynamic>> save(Map<String, dynamic> data) async {
    // 데이터 넘기는게 오래걸리니까 await => 당연히 메서드명 뒤에 async도 달아야됨
    Response response = await dio.post("/join", data: data);

    Map<String, dynamic> body = response.data; // response, header, body 중에 body에 해당
    Logger().d(body); // test 코드 작성 직접 해보기 (이전에 수업으로 했던 test 코드 가져와서 하면 됨)
    return body;
  }
}