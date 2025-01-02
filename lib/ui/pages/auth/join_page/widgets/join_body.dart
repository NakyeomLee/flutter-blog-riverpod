import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/data/gvm/session_gvm.dart';
import 'package:flutter_blog/ui/widgets/custom_auth_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_logo.dart';
import 'package:flutter_blog/ui/widgets/custom_text_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinBody extends ConsumerWidget {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    SessionGVM gvm = ref.read(sessionProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const CustomLogo("Blog"),
          CustomAuthTextFormField(
            text: "Username",
            controller: _username,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Email",
            controller: _email,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Password",
            obscureText: true,
            controller: _password,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "회원가입",
            // 회원가입 버튼 클릭하면 사용자가 회원가입을 위해 입력한 정보를 꺼내서 서버로 전송
            click: () {
              // 1. 사용자 입력값 받기

              // 2. 유효성 검사 (생략)

              // 3. GVM(GlobalViewModel)에게 책임 위임
              // trim() 없으면 안됨 (trim()은 문자열에서 앞뒤에 있는 공백(스페이스, 탭, 줄 바꿈 등)을 제거)
              gvm.join(_username.text.trim(), _email.text.trim(), _password.text.trim());
            },
          ),
          CustomTextButton(
            text: "로그인 페이지로 이동",
            click: () {
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}