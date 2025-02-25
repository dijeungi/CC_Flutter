import 'dart:convert';
import 'dart:math';

import 'package:cc_flutter/ranking.dart';
import 'package:cc_flutter/search.dart';
import 'package:cc_flutter/url/oauth2_url.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;

import 'main_page.dart';
import 'my_page.dart';
import 'naverlogin.dart';

class LoginPage extends StatefulWidget {

  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class BottomNavBar extends StatefulWidget {

  const BottomNavBar({super.key});


  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex; // 현재 선택된 인덱스

  @override
  void initState(){
    super.initState();
    _selectedIndex = 4;
    // _selectedIndex =  0;
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SearchPage(data: _selectedIndex,
                  id: '',
                  email: '',
                  nickname: ''),
        ),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              RankingPage(data: _selectedIndex,
                  id: '',
                  email: '',
                  nickname: ''),
        ),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MainPage(data: _selectedIndex,
                  id: '',
                  email: '',
                  nickname: ''),
        ),
      );
    }
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyPage(data: _selectedIndex,
                  id: '',
                  email: '',
                  nickname: ''),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey[70],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          bool isSelected = _selectedIndex == index; // 현재 선택된 아이템인지 확인
          return GestureDetector(
            onTap: () => _onItemTapped(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                top: isSelected ? 0 : 5, // 선택 시 살짝 위로 이동
                bottom: isSelected ? 5 : 0, // 선택 시 떠오르는 효과
              ),
              decoration: BoxDecoration(
                // color: isSelected ? Color.fromARGB(255, 252, 164, 114) : Colors.transparent, // ✅ 선택된 항목 배경색 변경
                borderRadius: BorderRadius.circular(10), // 둥근 모서리 추가
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0), // 내부 여백 조정
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIcon(index),
                      color: isSelected ? Colors.black : Colors.grey, // ✅ 선택된 아이콘 색상 변경
                      size: isSelected ? 27 : 25, // 선택된 아이콘 크기 증가
                    ),
                    Text(
                      _getLabel(index),
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.grey, // ✅ 선택된 텍스트 색상 변경
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // 아이콘 설정
  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.search;
      case 1:
        return Icons.account_balance;
      case 2:
        return Icons.home;
      case 3:
        return Icons.person;
      case 4:
        return Icons.settings;
      default:
        return Icons.help;
    }
  }

  // 라벨 설정
  String _getLabel(int index) {
    switch (index) {
      case 0:
        return "검색";
      case 1:
        return "랭킹";
      case 2:
        return "홈";
      case 3:
        return "MY";
      case 4:
        return "설정";
      default:
        return "";
    }
  }
}

class _LoginPageState extends State<LoginPage> {

  bool isLogin = false;


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
        backgroundColor: Color.fromARGB(255, 252, 164, 114),
        title: Text('Campus Concert',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25
          ),
        ),

        actions: [
        ],
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavBar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '로그인',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // 빨간색 구분선
              Container(
                height: 2,
                color: Colors.red,
              ),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SocialAuthScreen(
                              oauth2Url: Oauth2Url.naverAuthenUrl,
                              oauth2RedirectUrl: Oauth2Url.naverRedirectUrl,
                            ),
                          ));
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




