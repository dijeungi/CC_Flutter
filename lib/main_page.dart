import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cc_flutter/my_page.dart';
import 'package:cc_flutter/ranking.dart';
import 'package:cc_flutter/search.dart';
import 'package:cc_flutter/setting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'login.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:carousel_slider/carousel_controller.dart' as carousel_slider;

class MainPage extends StatefulWidget {
  final int data;
  final String id;
  final String email;
  final String nickname;
  const MainPage({super.key,required this.data,required this.id,required this.email,required this.nickname});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<List<Map<String, dynamic>>> _buttonsFuture;
  String? _categoryId;
  List<dynamic> categoryList = [];
  List<Map<String,dynamic>> _posterList = [];
  int _currentIndex = 0;
  late Timer _timer;
  late PageController _pageController;
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
    _buttonsFuture = fetchButtons();
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

    festivalInfoMain("CT");
  }


  Future<List<Map<String, dynamic>>> fetchButtons() async {
    final response = await http.get(

        Uri.parse('http://10.0.2.2:8080/api/common/list?id=CT'));

    if (response.statusCode == 200) {
      // ✅ JSON 데이터를 List<Map<String, dynamic>> 형식으로 반환
      final decodedBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(decodedBody);
      return jsonResponse.map((item) => item as Map<String, dynamic>).toList();
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
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
          // backgroundColor: Color.fromARGB(255, 224, 224, 224),
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
          bottomNavigationBar: BottomNavBar(id: widget.id,email: widget.email,nickname: widget.nickname),
          body: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: Color.fromARGB(255, 204, 204, 204),
                    width: 0.5

                )
              )
            ),
            child: Column(
              children: [
                //애니메이션 컨테이너
                SizedBox(
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
                Container(

                    child: SizedBox(
                      height: 15,
                    ),

                ),
                //카테고리 스크롤뷰
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _buttonsFuture, // ✅ API 호출
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator()); // 로딩 중 표시
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}')); // 에러 표시
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available')); // 데이터 없음 표시
                    } else {
                      // ✅ map()을 사용하여 버튼을 동적으로 생성
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,


                            child: Row(
                              children:
                              snapshot.data!.map((item) {
                                final bool isSelected = (item['id'] == _categoryId);
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0,bottom: 5.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(60, 60),
                                      backgroundColor: isSelected ? Color.fromARGB(255, 252, 164, 114) : Colors.grey[300], // 이전 'primary'
                                      foregroundColor: isSelected ? Colors.white : Colors.black,    // 이전 'onPrimary'
                                    ),
                                    onPressed: () => _onButtonPressed(item['id']), // 클릭 시 함수 호출
                                    child: Text(item['name'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),), // API 데이터 표시

                                  ),
                                );

                              }).toList(),




                          ),
                      );
                    }
                  },
                ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color:Color.fromARGB(255,204,204,204),
                          )
                        )
                      ),
                        child: SizedBox(
                            height: 5)
                    ),
                Container(
                  // width: 600,
                  height: 500,
                  // padding: EdgeInsets.only(left: 5,right: 5),
                  color: Colors.white,
                  // decoration: BoxDecoration(
                  //   border: Border(
                  //     top: BorderSide(
                  //         color: Color.fromARGB(255, 204, 204, 204),
                  //       width: 0.5
                  //     )
                  //   )
                  // ),
                  child: GridView.builder(
                                // 그리드가 화면 높이를 넘어가면 스크롤 가능.
                                // 만약 부모 스크롤과 충돌이 날 수 있다면 shrinkWrap, physics 등을 조정
                      padding: EdgeInsets.only(left: 25,right: 25),
                      shrinkWrap: true,
                      physics: ScrollPhysics(),

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                        crossAxisCount: 2, // 한 줄에 2개
                        crossAxisSpacing: 25, // 컬럼 간격
                        mainAxisSpacing: 15,  // 행 간격
                        childAspectRatio: 0.55, // 가로세로 비율 (1.0이면 정사각형)
                      ),
                      itemCount: _posterList.length,  // 데이터 개수
                      itemBuilder: (context, index) {
                         final item = _posterList[index];
                         final posterUrl = item['postImage']?.toString() ?? '';
                         final festivalTitle = item['festivalName']?.toString() ?? '';
                         String festivalLocation = item['placeName']?.toString() ?? '';
                         final salePercent =  (item['salePercent']?.toString()) ?? '';
                         final salePrice =  item['salePrice'] ?? '';

                         if(festivalLocation != '' && festivalLocation != null){
                            if(festivalLocation == 'PL02'){
                              festivalLocation = '대학로·';
                            }
                            else if(festivalLocation == 'PL03'){
                              festivalLocation = '서울·';
                            }
                            else if(festivalLocation == 'PL04'){
                              festivalLocation = '경기·인천·';
                            }
                            else if(festivalLocation == 'PL05'){
                              festivalLocation = '충청·대전·';
                            }
                            else if(festivalLocation == 'PL06'){
                              festivalLocation = '경상·대구·부산·';
                            }
                            else if(festivalLocation == 'PL07'){
                              festivalLocation = '전라·광주·';
                            }
                            else if(festivalLocation == 'PL08'){
                              festivalLocation = '강원·';
                            }
                            else if(festivalLocation == 'PL09'){
                              festivalLocation = '제주·';
                            }

                         }
                         final real_festivalLocation = festivalLocation+'연극';
                         final real_salePercent = salePercent+'%';
                         var f = NumberFormat('###,###,###,###원');
                         final real_salePrice = f.format(salePrice);


                        return Container(
                           color: Colors.white,
                           height: 800,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                 SizedBox(height: 10,),
                                // Expanded(
                                // child:
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),

                                  child: Image.network(
                                    posterUrl,
                                    fit: BoxFit.cover,
                                    width: 180,

                                    ),
                                ),
                                // ),
                                SizedBox(height: 10),
                                Text(real_festivalLocation,
                                  textAlign : TextAlign.left,
                                  style: TextStyle(fontSize: 12,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600),),
                                Text(festivalTitle,
                                textAlign : TextAlign.left,
                                style: TextStyle(fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(real_salePercent,
                                      textAlign : TextAlign.left,
                                      style: TextStyle(fontSize: 15,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w600),),
                                    Text(real_salePrice,
                                      textAlign : TextAlign.right,
                                      style: TextStyle(fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),),
                                  ],
                                )
                              ],
                            ),

                        );
                      },


                  ),
                ),
              ],
            ),
          ),
        ),

    );

  }
  void _onButtonPressed(String id) {
    if(id == 'CT01'){
      id = 'CT';
    }
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Button $id clicked')));
    setState(() {
      // 클릭된 id로 선택 상태 갱신
      _categoryId = id;
    });
    festivalInfoMain(id);
  }
}

class BottomNavBar extends StatefulWidget {
  final String id;
  final String email;
  final String nickname;
  const BottomNavBar({super.key,required this.id,required this.email,required this.nickname});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 2; // 현재 선택된 인덱스

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
