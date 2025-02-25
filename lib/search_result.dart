import 'dart:convert';
import 'package:cc_flutter/ranking.dart';
import 'package:cc_flutter/setting.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'login.dart';
import 'main_page.dart';
import 'my_page.dart';

class SearchResult extends StatefulWidget {
  final String searchResult;
  final String id;
  final String email;
  final String nickname;
  const SearchResult({super.key, required this.searchResult, required this.id, required this.email, required this.nickname});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

// ✅ SearchResponseDTO 클래스 정의
class SearchResponseDTO {
  final List<FestivalInfoDTO> festivalResults;
  final List<dynamic> actorResults;

  SearchResponseDTO({
    required this.festivalResults,
    required this.actorResults,
  });

  // ✅ fromJson 메소드 추가
  factory SearchResponseDTO.fromJson(Map<String, dynamic> json) {
    return SearchResponseDTO(
      festivalResults: (json['festivalResults'] as List<dynamic>)
          .map((e) => FestivalInfoDTO.fromJson(e))
          .toList(),
      actorResults: json['actorResults'] ?? [],
    );
  }
}

// ✅ FestivalInfoDTO 클래스 정의
class FestivalInfoDTO {
  final int id;
  final String festivalName;
  final String placeName;
  final String? postImage;

  FestivalInfoDTO({
    required this.id,
    required this.festivalName,
    required this.placeName,
    this.postImage,
  });

  factory FestivalInfoDTO.fromJson(Map<String, dynamic> json) {
    return FestivalInfoDTO(
      id: json['id'],
      festivalName: json['festivalName'],
      placeName: json['placeName'],
      postImage: json['postImage'],
    );
  }
}

class _SearchResultState extends State<SearchResult> {

  List<Map<String,dynamic>> titles = [];
  // ✅ searchData의 타입을 List<FestivalInfoDTO>로 변경
  List<FestivalInfoDTO> searchData = [];
  late String _searchResult;

  @override
  void initState() {
    super.initState();
    _searchResult = widget.searchResult;

    // ✅ API 호출
    festivalSearchResult(_searchResult);
    festivalSearchMain(7);
  }
  Future<void> festivalSearchMain(int limit) async {
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
        titles.addAll(parsedList);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  // ✅ 검색어 변경 시 호출
  void _onSearchChanged(String value) {
    setState(() {
      _searchResult = value;
    });
  }

  // ✅ 검색어 제출 시 API 호출
  void _onSubmit(String value) {
    festivalSearchResult(value);
  }

  // ✅ API 호출 및 상태 업데이트
  Future<void> festivalSearchResult(String searchValue) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/festival/search?searchKeyword=$searchValue'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);

      final Map<String, dynamic> jsonResponse = json.decode(decodedBody);
      final SearchResponseDTO searchResponse = SearchResponseDTO.fromJson(jsonResponse);

      setState(() {
        searchData.clear();
        searchData.addAll(searchResponse.festivalResults); // ✅ List<FestivalInfoDTO>를 추가
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
          backgroundColor: const Color.fromARGB(255, 252, 164, 114),
          title: const Text(
            'Campus Concert',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
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
                  '이 공연 및 배우를\n찾으시나요?',
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
                          decoration: const InputDecoration(
                            hintText: "검색어를 입력하세요.",
                            border: InputBorder.none,
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

                // ✅ ListView.builder로 검색 결과 표시
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: searchData.length,
                  itemBuilder: (context, index) {
                    final item = searchData[index];

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
                            child: item.postImage != null
                                ? Image.network(item.postImage!)
                                : const Icon(Icons.image, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),

                          // 타이틀
                          Expanded(
                            child: Text(
                              item.festivalName,
                              style: const TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),
                Container(
                  height: 2,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),

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

                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(data : 0,id: widget.id,email: widget.email,nickname: widget.nickname),
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
    // _selectedIndex =  0;
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
