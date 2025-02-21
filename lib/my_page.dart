import 'package:cc_flutter/main_page.dart';
import 'package:cc_flutter/ranking.dart';
import 'package:cc_flutter/search.dart';
import 'package:cc_flutter/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  final int data;
  const MyPage({super.key,required this.data});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
        ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "어떤 티켓을 찾으시나요?"
                  const Text(
                    '어떤 티켓을\n찾으시나요?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 검색창 (돋보기 아이콘 + 안내문구)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '원하는 티켓을 검색해보세요!',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 빨간색 구분선
                  Container(
                    height: 2,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),

                  // "추천 검색어"
                  const Text(
                    '추천 검색어',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 추천 검색어 영역 (배너)
                  // 이미지 예시 (가로로 꽉 차게)
                  Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    // 실제 배너 이미지가 있다면 Image.network(...)로 교체
                    child: const Center(child: Text('배너 이미지 영역', style: TextStyle(color: Colors.black54))),
                  ),

                  const SizedBox(height: 20),

                  // "인기 검색어" + 날짜
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '인기 검색어',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '2025-02-20 집계 기준',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 인기 검색어 목록
                  // 예시로 7개 항목을 ListView.builder로 표시(단, SingleChildScrollView 내부이므로 shrinkWrap 필요)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      // 예시 데이터
                      final titles = [
                        '쉬어매드니스',
                        '죽여주는 이야기',
                        '브레드이발소 : 빵스타 대격돌',
                        '김종욱 찾기',
                        '2호선 세입자',
                        '옥탑방 고양이',
                        '은밀한 연애',
                      ];
                      // 예시로 상승/하강/유지 마크
                      final icons = [
                        '유지', // -,
                        '상승', // ▲,
                        '유지',
                        '상승',
                        '하강',
                        '유지',
                        '상승',
                      ];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            // 순위
                            Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 포스터/아이콘 (예시)
                            Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey.shade200,
                              // 실제 이미지는 Image.network(...) 사용
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                            // 타이틀
                            Expanded(
                              child: Text(
                                titles[index],
                                style: const TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 상승/하강/유지 표시
                            _buildTrendIcon(icons[index]),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          actions: [
          ],
          automaticallyImplyLeading: false,



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
    if(index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingPage(data: _selectedIndex),
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