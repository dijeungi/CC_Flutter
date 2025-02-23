import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchResult extends StatefulWidget {
  final String searchResult;
  const SearchResult({super.key, required this.searchResult});

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
  // ✅ searchData의 타입을 List<FestivalInfoDTO>로 변경
  List<FestivalInfoDTO> searchData = [];
  late String _searchResult;

  @override
  void initState() {
    super.initState();
    _searchResult = widget.searchResult;

    // ✅ API 호출
    festivalSearchResult(_searchResult);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
