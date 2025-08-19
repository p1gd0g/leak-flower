import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:leak_flower/controller/pocketbase.dart';

final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final pb = Get.put(PBController());
    return Stack(
      children: [
        FlutterLogin(
          onSignup: (signupData) async {
            try {
              await pb.register(
                signupData.name!,
                signupData.password!,
                signupData.password!,
              );
              Get.log('注册成功: ${pb.authStore.record}');
              await pb.login(signupData.name!, signupData.password!);
              Get.log('登录成功: ${pb.authStore.record}');
              Get.back();
              return null;
            } catch (e) {
              Get.log('注册失败: $e');
              return e.toString();
            }
          },
          onLogin: (loginData) async {
            try {
              await pb.login(loginData.name, loginData.password);
              Get.log('登录成功: ${pb.authStore.record}');
              Get.back();
              return null;
            } catch (e) {
              Get.log('登录失败: $e');
              return e.toString();
            }
          },
          onRecoverPassword: (name) {
            // TODO 以后再做恢复密码的处理
            return Future.value('请联系客服（转人工）');
          },
          messages: LoginMessages(
            userHint: '邮箱',
            passwordHint: '密码',
            forgotPasswordButton: '忘记密码？',
            loginButton: '登录',
            signupButton: '注册',
            goBackButton: '返回',
            recoverPasswordButton: '恢复',
            recoverPasswordIntro: '',
            recoverPasswordDescription: '',
            confirmPasswordHint: '确认密码',
            confirmPasswordError: '两次输入的密码不一致',
          ),
          userType: LoginUserType.email,
          userValidator: (value) {
            if (value == null || value.isEmpty || !email.hasMatch(value)) {
              return '请输入正确的邮箱地址';
            }
            return null;
          },
          passwordValidator: (value) {
            if (value == null || value.isEmpty || value.length < 6) {
              return '密码长度至少为 6 个字符（老用户输入新密码即可）';
            }
            return null;
          },
          logoTag: 'login_logo',
          titleTag: 'login_title',
          showDebugButtons: kDebugMode,
          hideForgotPasswordButton: true,
          disableCustomPageTransformer: true,
          savedEmail: pb.authStore.record?.collectionName ?? '',
        ),
        Container(
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
