import 'dart:convert';
import 'dart:math';

import 'package:cc_flutter/main_page.dart';
import 'package:cc_flutter/search.dart';
import 'package:cc_flutter/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'my_page.dart';

class RankingPage extends StatefulWidget {
  final int data;
  final String id;
  final String email;
  final String nickname;
  const RankingPage({super.key,required this.data,required this.id,required this.email,required this.nickname});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Map<String, dynamic>> _buttonsFuture = [];
  List<Map<String,dynamic>> top3 = [];
  List<Map<String,dynamic>> rankingItems = [];
  // late PageController _pageController;
  List<Map<String,dynamic>> _posterList = [];
  Future<void> fetchButtons() async {
    final response = await http.get(

        Uri.parse('http://10.0.2.2:8080/api/common/list?id=CT'));

    if (response.statusCode == 200) {
      // ✅ JSON 데이터를 List<Map<String, dynamic>> 형식으로 반환
      final decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(decodedBody);
      final List<Map<String,dynamic>> parsedList = jsonResponse.map((item) => item as Map<String, dynamic>).toList();
      setState(() {
    _buttonsFuture.addAll(parsedList);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<void> festivalRankingTop3(int limit) async {
    // _posterList.clear();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/festival/ranking/limit?limit=$limit'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // ✅ JSON 데이터를 List<Map<String, dynamic>> 형식으로 반환
      final decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(decodedBody);
      // final newItems = (jsonResponse).cast<String>();
      final List<Map<String,dynamic>> parsedList = jsonResponse.map((e)=> e as Map<String, dynamic>).toList();
      setState(() {
        top3.addAll(parsedList);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<void> festivalInfoMain(String categoryId) async {
    _posterList.clear();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/festival/list/category?categoryId=$categoryId'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      // ✅ JSON 데이터를 List<Map<String, dynamic>> 형식으로 반환
      final decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(decodedBody);
      // final newItems = (jsonResponse).cast<String>();
      final List<Map<String,dynamic>> parsedList = jsonResponse.map((e)=> e as Map<String, dynamic>).toList();
      setState(() {
        _posterList.addAll(parsedList);
        top3.clear();
        top3.addAll(parsedList.sublist(0,min(3,parsedList.length)));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _pageController = PageController();
      fetchButtons();
      festivalRankingTop3(3);
      festivalInfoMain("CT");
    });
  }


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
        body: SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.all(16.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ranking',
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
          const SizedBox(height: 16),

          SizedBox(
            height: 130,
            child: _buttonsFuture.isNotEmpty ? GridView.builder(
              shrinkWrap: true,

                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 한 줄에 4개의 아이템
                crossAxisSpacing: 12, // 열 간격
                mainAxisSpacing: 12, // 행 간격
                childAspectRatio: 1.8, // 정사각형 비율
              ),
                itemCount: _buttonsFuture.length, // 8개의 아이템
                itemBuilder: (context, index) {
                final item = _buttonsFuture[index];
                return GestureDetector(
                onTap: () {
                // ScaffoldMessenger.of(context).showSnackBar(
                // SnackBar(content: Text('${item['name']} 클릭됨')),
                // );
                 festivalInfoMain(item['id']);
              },
              child: Container(
              decoration: BoxDecoration(
              color: Colors.purple.shade100, // 배경색
              borderRadius: BorderRadius.circular(10), // 모서리 둥글게
              boxShadow: [
              BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
              )
              ],
              ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // Icon(
              // IconData(int.parse(item['icon']!), fontFamily: 'MaterialIcons'),
              // size: 32,
              // color: Colors.purple,
              // ),
              // const SizedBox(height: 8),
              Text(
              item['name']!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              ],
              ),
              ),
              );

              }

                )
                : Center(child: CircularProgressIndicator(),)
          ),

          // 빨간색 구분선
          Container(
            height: 2,
            color: Colors.red,
          ),
          const SizedBox(height: 16),

          // 상단 날짜 표시
                     Text(
            '2025.02.24 10:30 기준',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
           SizedBox(height: 20),

          // 상단 3개의 카드 (가로 배치)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: top3.isNotEmpty ?
              top3.asMap().entries.map((entry) {
              int index = entry.key + 1; // 인덱스를 1부터 시작하게 설정
              var item = entry.value;
              return Expanded(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 이미지
                      ClipRRect(
                        borderRadius:  BorderRadius.vertical(top: Radius.circular(8)),
                        child: Image.network(
                          item['postImage'],
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 순위 및 상승/하락 표시
                            Row(
                              children: [
                                Container(
                                  padding:  EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    index.toString(),
                                    style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                 // SizedBox(width: 8),
                                // Text(
                                //   item['status']!,
                                //   style: TextStyle(
                                //     color: item['status']!.contains('▲') ? Colors.red : (item['status']!.contains('▼') ? Colors.blue : Colors.grey),
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ],
                            ),
                             SizedBox(height: 8),
                            Text(
                              item['festivalName']!,
                              style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                            //  SizedBox(height: 4),
                            // Text(item['venue']!, style:  TextStyle(color: Colors.grey)),
                            // Text(item['date']!, style:  TextStyle(color: Colors.grey)),
                            //  SizedBox(height: 4),
                            // Text('예매율 ${item['ranking']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList()
                : [SizedBox()] ,
          ),
          const SizedBox(height: 16),

          // 하단 목록
          _posterList.isNotEmpty ?
          ListView.builder(
            itemCount: _posterList.length-3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (_posterList.isEmpty || index + 3 >= _posterList.length) {
                return SizedBox(); // 데이터가 없으면 빈 박스 반환
              }
              final item = _posterList[index+3];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    // 순위
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (index+4).toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 이미지
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['postImage']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 제목 및 정보
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['festivalName']!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          // const SizedBox(height: 4),
                          // Text(item['venue']!, style: const TextStyle(color: Colors.grey)),
                          // Text(item['date']!, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),

                    // 예매율
                    Text(
                      item['ranking']!.toString(),
                      style: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          )
          : SizedBox(),
      ]
      ),






      ),
        ),



        //하단 바
        bottomNavigationBar: BottomNavBar(data : widget.data,id:widget.id,email:widget.email,nickname:widget.nickname),
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
          builder: (context) => MyPage(data: _selectedIndex,id: widget.id,email: widget.email,nickname: widget.nickname),
        ),
      );
    }
    if(index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingPage(data: _selectedIndex,id: widget.id,email: widget.email,nickname: widget.nickname),
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