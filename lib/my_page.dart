import 'package:cc_flutter/main_page.dart';
import 'package:cc_flutter/ranking.dart';
import 'package:cc_flutter/search.dart';
import 'package:cc_flutter/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class MyPage extends StatefulWidget {
  final int data;
  final String id;
  final String email;
  final String nickname;
  const MyPage({super.key,required this.data,required this.id,required this.email,required this.nickname});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final List<Map<String, dynamic>> gridItems = [
    {'title': '예매내역', 'icon': Icons.confirmation_num_outlined},
    {'title': '나의 이용후기', 'icon': Icons.rate_review_outlined},
    {'title': '이용가능티켓', 'icon': Icons.receipt_long},
    {'title': '취소/환불내역', 'icon': Icons.cancel_outlined},
    {'title': '고객센터', 'icon': Icons.headset_mic_outlined},
  ];

  final List<Map<String, dynamic>> iconItems = [
    {'title': '친구초대', 'icon': Icons.group_add, 'point': '10% 할인'},
    {'title': '쿠폰/상품권 등록', 'icon': Icons.card_giftcard},
    {'title': '자주묻는질문', 'icon': Icons.help_outline},
    {'title': '1:1문의', 'icon': Icons.chat_bubble_outline},
    {'title': '회원정보수정', 'icon': Icons.person_outline},
    {'title': '푸시알림 설정방법', 'icon': Icons.notifications_active_outlined},
  ];

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
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Welcome to CC',style: TextStyle(fontSize: 30)),
                      TextSpan(text: '😊', style: TextStyle(fontSize: 30)),
                    ],
                  ),
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: gridItems.take(2).map((item) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'],size: 24,color: Color.fromARGB(255, 252, 164, 114),)
                  ,
                  Text(item['title'],
                    style: TextStyle(color: Colors.black, fontSize: 16))
              ]
              )


              ),
            );
          }).toList(),
        ),

        // 두 번째 줄 - 3개
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: gridItems.skip(2).map((item) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.all(8),
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'],size: 24,color: Color.fromARGB(255, 252, 164, 114),)
                        ,
                        Text(item['title'],
                            style: TextStyle(color: Colors.black, fontSize: 16))
                      ]
                  )
              ),
            );
          }).toList(),
        ),

                const SizedBox(height: 20),

                // Icon List
                GridView.builder(
                  shrinkWrap: true, // 스크롤 문제 방지
                  physics: NeverScrollableScrollPhysics(), // 부모 스크롤에 맞추기
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2열로 정렬
                    childAspectRatio: 5, // 아이템의 비율 (가로로 넓게 설정)
                    crossAxisSpacing: 16, // 열 간격
                    mainAxisSpacing: 12, // 행 간격
                  ),
                  padding: EdgeInsets.only(left: 15),
                  itemCount: iconItems.length, // 아이템 개수
                  itemBuilder: (context, index) {
                    final item = iconItems[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(item['icon'], color: Colors.black54),
                        const SizedBox(width: 8),
                        Text(
                          item['title'],

                          style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 15),
                        ),
                        if (item.containsKey('point'))
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              item['point'],
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // 고객센터
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("고객센터 >", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text("1599-3089", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text("월-금 10:00-18:00 (주말·공휴일 휴무)", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                 SizedBox(height:30),
                 ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // minimumSize: Size(100, 60),
                    backgroundColor:  Color.fromARGB(255, 252, 164, 114), // 이전 'primary'
                    foregroundColor: Colors.white,    // 이전 'onPrimary'
                  ),
                  onPressed: () => (
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      ),

                  ), // 클릭 시 함수 호출
                  child: Text('로그인',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),), // API 데이터 표시

                ),
              ],
            ),

          ),
        ),
        //하단 바
        bottomNavigationBar: BottomNavBar(data : widget.data,id: widget.id,email: widget.email,nickname: widget.nickname),
      ),
    );
  }
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
    if(index == 4) {
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