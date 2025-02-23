import 'dart:async';
import 'dart:convert';

import 'package:cc_flutter/main_page.dart';
import 'package:cc_flutter/ranking.dart';
import 'package:cc_flutter/search_result.dart';
import 'package:cc_flutter/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'my_page.dart';

class SearchPage extends StatefulWidget {
  final int data;

  const SearchPage({super.key,required this.data});


  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _currentIndex = 0;
  late Timer _timer;
  late PageController _pageController;
  late String searchResult;
  DateTime now = DateTime.now();
  List<Map<String,dynamic>> titles = [];
  // late String formattedDate; // ✅ yyyy-MM-dd 형식

  final List<String> _imageList = [
    "https://image.toast.com/aaaaab/ticketlink/TKL_7/PC_BigBanner_2%EC%9B%94%EB%A7%81%ED%81%AC%ED%94%BD.jpg",
    "https://image.toast.com/aaaaab/ticketlink/TKL_1/PC_BigBanner_2025SoundberryTheater.jpg",
    "https://image.toast.com/aaaaab/ticketlink/TKL_10/PC_BigBanner_%EC%A7%80%ED%82%AC%EC%95%A4%ED%95%98%EC%9D%B4%EB%93%9C.jpg",
    "https://image.toast.com/aaaaab/ticketlink/TKL_8/PC_BigBanner_%EB%82%98%EC%83%81%ED%98%84%EC%94%A8%EB%B0%B4%EB%93%9C.jpg",
    "https://image.toast.com/aaaaab/ticketlink/TKL_9/PC_BigBanner_%EC%84%B1%EC%9B%85.jpg",
    "https://image.toast.com/aaaaab/ticketlink/TKL_10/PC_BigBanner_%EC%97%B0%EA%B7%B9%EA%BD%83%EC%9D%98%EB%B9%84%EB%B0%80_0107.jpg",
    "https://image.toast.com/aaaaab/ticketlink/TKL_4/PC_BigBanner_%EC%96%B4%EC%8D%B8%EB%B6%80%EC%82%B0.jpg",
    "https://image.toast.com/aaaaab/ticketlink/TKL_1/PC_BigBanner_%EB%AA%85%EC%84%B1%ED%99%A9%ED%9B%84(1).jpg",
    "https://image.toast.com/aaaaab/ticketlink/TKL_5/PC_BigBanner_%EB%B9%84%EC%97%94%EB%82%981900.jpg",
    "https://image.toast.com/aaaaab/ticketlink/TKL_4/PC_BigBanner_%EC%84%9C%EC%9A%B8%EC%BB%A4%ED%94%BC%EC%97%91%EC%8A%A4%ED%8F%AC.jpg"
  ];
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  void _onSearchChanged(String value) {
    setState(() {
      searchResult = value;
    });
  }
  void _onSubmit(String value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResult(searchResult: value),
        ),
      );
  }
  @override
  void dispose() {
    // Timer는 꼭 cancel로 정리해 주어야 함
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    // formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // formattedDate = '$formattedDate 집계 기준';
    _pageController = PageController();

    // 3초마다 index를 바꿔가며 자동으로 페이지 이동
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _imageList.length;
        // print(_timer);
        // PageView 페이지를 애니메이션과 함께 이동
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
    festivalSearchMain();
  }

  Future<void> festivalSearchMain() async {
    // _posterList.clear();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/festival/ranking/limit'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // ✅ JSON 데이터를 List<Map<String, dynamic>> 형식으로 반환
      final decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(decodedBody);
      // final newItems = (jsonResponse).cast<String>();
      final List<Map<String,dynamic>> parsedList = jsonResponse.map((e)=> e as Map<String, dynamic>).toList();
      setState(() {
        titles.addAll(parsedList);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
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

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "어떤 티켓을 찾으시나요?"
                  const Text(
                    '어떤 공연 및 배우를\n찾으시나요?',
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
                          child: TextField(
                            onChanged: _onSearchChanged,
                            onSubmitted: _onSubmit,
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
                   Text(
                    '추천 검색어',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )

                  ,
                  SizedBox(height: 10),

                  // 추천 검색어 영역 (배너)
                  // 이미지 예시 (가로로 꽉 차게)
                  Container(
                    height: 120,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    // 실제 배너 이미지가 있다면 Image.network(...)로 교체
                    child: SizedBox(
                      height: 200,
                      width: double.infinity, // ✅ 너비를 화면에 꽉 차게
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _imageList.length,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color.fromARGB(255, 204, 204, 204),
                                        width: 0.5

                                    )

                                )
                            ),
                            child: Image.network(
                              _imageList[index],
                              fit: BoxFit.fill, // ✅ 비율 유지 + 화면에 꽉 차게 표시됨
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                   SizedBox(height: 20),

                  // "인기 검색어" + 날짜
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '인기 검색어',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formattedDate+' 기준',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                   SizedBox(height: 16),

                  // 인기 검색어 목록
                  // 예시로 7개 항목을 ListView.builder로 표시(단, SingleChildScrollView 내부이므로 shrinkWrap 필요)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      final item = titles[index];
                      final posterUrl = item['postImage']?.toString() ?? '';
                      final festivalTitle = item['festivalName']?.toString() ?? '';
                      // String festivalLocation = item['placeName']?.toString() ?? '';
                      // final salePercent =  (item['salePercent']?.toString()) ?? '';
                      // final salePrice =  item['salePrice'] ?? '';
                      // 예시 데이터
                      // final titles = [
                      //   '쉬어매드니스',
                      //   '죽여주는 이야기',
                      //   '브레드이발소 : 빵스타 대격돌',
                      //   '김종욱 찾기',
                      //   '2호선 세입자',
                      //   '옥탑방 고양이',
                      //   '은밀한 연애',
                      // ];
                      // 예시로 상승/하강/유지 마크
                      final icons = [
                        '상승', // -,
                        '상승', // ▲,
                        '상승',
                        '상승',
                        '상승',
                        '상승',
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
                              child: Image.network(
                                  posterUrl
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 타이틀
                            Expanded(
                              child: Text(
                                festivalTitle,
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

          // actions: [
          // ],
          // automaticallyImplyLeading: false,
          //
          //
          //


        //하단 바
        bottomNavigationBar: BottomNavBar(data : widget.data),
      ),
    );
  }
}
Widget _buildTrendIcon(String status) {
  switch (status) {
    case '상승':
      return const Text('▲', style: TextStyle(color: Colors.redAccent));
    case '하강':
      return const Text('▼', style: TextStyle(color: Colors.blueAccent));
    default:
      return const Text('-', style: TextStyle(color: Colors.grey));
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