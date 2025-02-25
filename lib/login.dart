import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_naver_login/flutter_naver_login.dart';
// import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
 import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  // final String dotenv_clientId = dotenv.env["NAVER_CLIENT_ID"] ?? "";
  // final String dotenv_clientPw = dotenv.env["NAVER_CLIENT_SECRET"] ?? "";
  // final String dotenv_redirectUri = dotenv.env["NAVER_REDIRECT_URL"] ?? "";
  // static String generateRandomState(int length) {
  //   const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  // }
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // String? _navernickname;
  // String? _naveremail;
  // String? _naverid;
  // String? _naverAccessToken;
  // Future<void> _loginWithNaver() async {
  //   try {
  //     final NaverLoginResult result = await FlutterNaverLogin.logIn();
  //
  //     if (result.status == NaverLoginStatus.loggedIn) {
  //       final NaverAccessToken accessToken = await FlutterNaverLogin.currentAccessToken;
  //       final NaverAccountResult user = result.account;
  //
  //       setState(() {
  //         _naverAccessToken = accessToken.accessToken;
  //         _naveremail = user.email ?? '이메일 없음';
  //         _navernickname = user.nickname ?? '닉네임 없음';
  //       });
  //
  //       print('네이버 로그인 성공: ${user.nickname}, ${user.email}, ${accessToken.accessToken}');
  //     } else {
  //       print('네이버 로그인 실패: ${result.errorMessage}');
  //     }
  //   } catch (e) {
  //     print('네이버 로그인 중 오류 발생: $e');
  //   }
  // }
  //
  // Future<void> _logout() async {
  //   await FlutterNaverLogin.logOut();
  //   setState(() {
  //     _naverAccessToken = null;
  //     _naveremail = null;
  //     _navernickname = null;
  //   });
  //   print('네이버 로그아웃 성공');
  // }
// 사용 예시:
//   final String state = LoginPage.generateRandomState(32); // ✅ 32자 랜덤 문자열 생성


  //카카오
  Future<List<Map<String, dynamic>>> fetchButtons(String accessToken) async {
    final response = await http.get(

        Uri.parse('http://10.0.2.2:8080/api/member/kakao?accessToken=$accessToken'));

    if (response.statusCode == 200) {
      // ✅ JSON 데이터를 List<Map<String, dynamic>> 형식으로 반환
      final decodedBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(decodedBody);
      List<Map<String, dynamic>> result = jsonResponse.entries.map((entry) {
        return {
          entry.key: entry.value
        };
      }).toList();
      return result;
    } else {
      throw Exception('Failed to load data');
    }
  }
  String? _kakaonickname;
  String? _kakaoemail;
  String? _kakaoid;
  Future<void> _loginWithKakao() async {
    try {
      // ✅ 'isKakaoTalkLoginAvailable()' 대신 'loginWithKakaoTalk()' 사용
      await UserApi.instance.loginWithKakaoTalk().then((_) async {
        OAuthToken token = await TokenManagerProvider.instance.manager.getToken() as OAuthToken;
        User user = await UserApi.instance.me();
        setState(() {
          _kakaonickname = user.kakaoAccount?.profile?.nickname ?? '닉네임 없음';
          _kakaoemail = user.kakaoAccount?.email ?? '이메일 없음';
          _kakaoid = user.id.toString() ?? 'id 없음';
        });
        print('카카오 로그인 성공: $_kakaonickname,$_kakaoemail,$_kakaoid,$token');
      }).catchError((error) async {
        // ✅ 카카오톡이 설치되지 않았을 때 계정 로그인 사용
        await UserApi.instance.loginWithKakaoAccount();
        OAuthToken token = await TokenManagerProvider.instance.manager.getToken() as OAuthToken;
        User user = await UserApi.instance.me();
        setState(() {
          _kakaonickname = user.kakaoAccount?.profile?.nickname ?? '닉네임 없음';
          _kakaoemail = user.kakaoAccount?.email ?? '이메일 없음';
          _kakaoid = user.id.toString() ?? 'id 없음';
        });
        print('카카오 계정 로그인 성공: $_kakaonickname,$_kakaoemail,$_kakaoid,$token');
        fetchButtons(token.accessToken.toString());
      });
    } catch (e) {
      print('카카오 로그인 실패: $e');
    }
  }

  Future<void> _kakaologout() async {
    try {
      await UserApi.instance.logout();
      setState(() {
        _kakaonickname = '';
      });
      print('로그아웃 성공');
    } catch (e) {
      print('로그아웃 실패: $e');
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
                    onTap: () {
                      // _loginWithNaver();
                    },
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




