import 'package:flutter_blog/data/repository/user_repository.dart';

void main() async {
  UserRepository userRepository = const UserRepository();
  await userRepository.findByUsernameAndPassword({"username": "ssa", "password": "1234"});
}