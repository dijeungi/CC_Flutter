import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
// import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _nickname;
  Future<void> _loginWithKakao() async {
    try {
      // ✅ 에뮬레이터에서는 직접 계정 로그인만 사용하도록 변경
      await UserApi.instance.loginWithKakaoAccount();

      User user = await UserApi.instance.me();
      setState(() {
        _nickname = user.kakaoAccount?.profile?.nickname ?? '닉네임 없음';
      });
      print('카카오 로그인 성공: $_nickname');
    } catch (e) {
      print('카카오 로그인 실패: $e');
    }
  }
  // 에뮬레이터 기준
  // Future<void> _loginWithKakao() async {
  //   try {
  //     if (await isKakaoTalkInstalled()) {
  //       await UserApi.instance.loginWithKakaoTalk();
  //     } else {
  //       await UserApi.instance.loginWithKakaoAccount();
  //     }
  //
  //     User user = await UserApi.instance.me();
  //     setState(() {
  //       _nickname = user.kakaoAccount?.profile?.nickname ?? '닉네임 없음';
  //     });
  //     print('카카오 로그인 성공: $_nickname');
  //   } catch (e) {
  //     print('카카오 로그인 실패: $e');
  //   }
  // }

  Future<void> _logout() async {
    try {
      await UserApi.instance.logout();
      setState(() {
        _nickname = null;
      });
      print('로그아웃 성공');
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {},
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('로그인', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // 아이디 입력 필드
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline, color: Colors.black54),
                  hintText: '아이디',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              // 비밀번호 입력 필드
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.black54),
                  hintText: '비밀번호',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 252, 164, 114),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('로그인', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              // 아이디 찾기, 비밀번호 찾기, 회원가입
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {}, child: Text('아이디 찾기', style: TextStyle(color: Colors.black54))),
                  Text('|', style: TextStyle(color: Colors.black54)),
                  TextButton(onPressed: () {}, child: Text('비밀번호 찾기', style: TextStyle(color: Colors.black54))),
                  Text('|', style: TextStyle(color: Colors.black54)),
                  TextButton(onPressed: () {}, child: Text('회원가입', style: TextStyle(color: Colors.black54))),
                ],
              ),
              const SizedBox(height: 24),
              // 간편 로그인
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.black12, thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('간편 로그인', style: TextStyle(color: Colors.black54)),
                  ),
                  Expanded(child: Divider(color: Colors.black12, thickness: 1)),
                ],
              ),
              const SizedBox(height: 16),
              // 네이버, 카카오 로그인 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  GestureDetector(
                    onTap: () {
                      _loginWithKakao();
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.yellow,
                          child: Text('K', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24)),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // child: Text('최근에 로그인 했어요!', style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 하단 도움말 텍스트
              Text(
                '회원가입/로그인에 문제가 있어요! >',
                style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }




