import 'package:flutter/material.dart';
// import 'package:flutter_project/language_provider.dart';
// import 'best_recommand.dart';
import 'main_page.dart';

class LoadingPage extends StatefulWidget {
  // final ValueChanged<String> onLanguageSelected;

  const LoadingPage( {super.key});

  @override
  State<LoadingPage> createState() => _StartPageState();
}

class _StartPageState extends State<LoadingPage> {

  @override
  void initState() {
    super.initState();
  }

  void _goToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(data: 2,
          // selectedLanguage: _selectedLanguage, // Pass selected language as argument
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToNextPage,
      child: Scaffold(

        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7, // 상단 70% 차지
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 252, 164, 114), //#FCA472
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                )
              ),
            ),
            // 로그인 때 활용
            // Align(
            //   alignment: Alignment.center,
            //   child: Container(
            //     width: MediaQuery.of(context).size.width * 0.8,
            //     height: 400,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.2),
            //           blurRadius: 10,
            //           spreadRadius: 2,
            //         )
            //       ],
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         SizedBox(height: 80), // 아이콘이 겹치는 위치 확보
            //         Text(
            //           "환영합니다!",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            //         ),
            //         SizedBox(height: 20),
            //         ElevatedButton(
            //           onPressed: () {},
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.black,
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10)),
            //             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //           ),
            //           child: Text("CC"),
            //         ),
            //         SizedBox(height: 10),
            //
            //       ],
            //     ),
            //   ),
            // ),
            // Header 텍스트 영역
            Positioned(
              child: Container(
                alignment: Alignment.center,
                  child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 100),
                      Text("Campus Concert",
                        style: TextStyle(
                        fontSize: 45,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      Text("대학로 연극의 새로운 관점",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                        ),
                      ),

                      
                    ],
                  ),
                ),
              ),

            //CC 이미지 넣는 곳
            Positioned(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 230),
                    Image.asset
                      ("images/CC.jpg",
                    width: 350,
                    height: 400,
                    fit: BoxFit.cover
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 780),
                    Container(
                      alignment: Alignment.center,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 252, 164, 114),
                        borderRadius: BorderRadius.circular(35),
                      ),
                    child: Text("잠시 후 실행됩니다.",
                      style: TextStyle(
                          fontSize: 40,
                          color:Colors.white,


                      ),

                    ),

                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
