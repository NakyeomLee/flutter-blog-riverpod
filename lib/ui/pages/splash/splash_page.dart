import 'package:flutter/material.dart';
import 'package:flutter_blog/data/gvm/session_gvm.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(sessionProvider.notifier).autoLogin();

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/splash.gif',
          // infinity : 무한 확장
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}