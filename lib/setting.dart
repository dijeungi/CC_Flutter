import 'package:cc_flutter/main_page.dart';
import 'package:cc_flutter/ranking.dart';
import 'package:cc_flutter/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_page.dart';

class SettingPage extends StatefulWidget {
  final int data;
  const SettingPage({super.key,required this.data});

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
        //하단 바
        bottomNavigationBar: BottomNavBar(data : widget.data),
      ),
    );
  }
}
class BottomNavBar extends StatefulWidget {
  final int data;
  const BottomNavBar({super.key,required this.data});


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
          builder: (context) => SearchPage(data: _selectedIndex),
        ),
      );
    }
    if(index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RankingPage(data: _selectedIndex),
        ),
      );
    }
    if(index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(data: _selectedIndex),
        ),
      );
    }
    if(index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyPage(data: _selectedIndex),
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