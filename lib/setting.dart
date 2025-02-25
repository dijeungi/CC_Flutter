import 'package:cc_flutter/login.dart';
import 'package:cc_flutter/main_page.dart';
import 'package:cc_flutter/ranking.dart';
import 'package:cc_flutter/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_page.dart';

class SettingPage extends StatefulWidget {
  final int data;
  final String id;
  final String email;
  final String nickname;
  const SettingPage({super.key,required this.data,required this.id,required this.email,required this.nickname});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
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
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            SizedBox(height: 10,),
            _buildProfileTile('김범석', '사용자 계정', Icons.person),
            SizedBox(height: 30,),
            _buildTile('티켓 내역', '티켓 구매 내역', Icons.lightbulb),
            SizedBox(height: 10,),
            _buildTile('', 'Wi-Fi · 블루투스 · SIM 관리자', Icons.wifi),
            SizedBox(height: 10,),
            _buildTile('기기 간 연결', 'Quick Share · Android Auto', Icons.devices),
            SizedBox(height: 10,),
            _buildTile('T 로밍', '데이터 로밍 · 로밍 설정', Icons.language),
            SizedBox(height: 10,),
            _buildTile('Galaxy AI', '대화 어시스트 · 노트 어시스트 · 포토 어시스트', Icons.stars),
            SizedBox(height: 10,),
            // _buildTile('모드 및 루틴', '모드 · 루틴', Icons.check_circle),
            // SizedBox(height: 10,),
          ],
        ),

        //하단 바
        bottomNavigationBar: BottomNavBar(data : widget.data,id: widget.id,email: widget.email,nickname: widget.nickname),
      ),
    );
  }
}
Widget _buildProfileTile(String title, String subtitle, IconData icon) {
  return ListTile(

    leading: Icon(icon, size: 40, color: Colors.black),
    title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 18)),
    subtitle: Text(subtitle, style: const TextStyle(color: Colors.black54)),
    trailing: const Icon(Icons.person_outline, color: Colors.black54),
    tileColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
  );

}

Widget _buildTile(String title, String subtitle, IconData icon) {
  return ListTile(
    leading: Icon(icon, size: 30, color: Colors.black),
    title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16)),
    subtitle: Text(subtitle, style: const TextStyle(color: Colors.black54)),
    trailing: const Icon(Icons.chevron_right, color: Colors.black54),
    tileColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  );
}
class BottomNavBar extends StatefulWidget {
  final int data;
  final String id;
  final String email;
  final String nickname;
  const BottomNavBar({super.key,required this.data,required this.id,required this.email,required this.nickname});


  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex; // 현재 선택된 인덱스

  @override
  void initState(){
    super.initState();
    _selectedIndex = widget.data;
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(data: _selectedIndex,id: widget.id,email: widget.email,nickname: widget.nickname),
        ),
      );
    }
    if(index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RankingPage(data: _selectedIndex,id: widget.id,email: widget.email,nickname: widget.nickname),
        ),
      );
    }
    if(index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(data: _selectedIndex,id: widget.id,email: widget.email,nickname: widget.nickname),
        ),
      );
    }
    if(index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),//data: _selectedIndex,id: widget.id,email: widget.email,nickname: widget.nickname
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