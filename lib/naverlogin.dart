import 'package:cc_flutter/my_page.dart';
import 'package:flutter/material.dart';
// import 'package:cc_flutter/url/oauth2_url.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './token_info.dart';

class SocialAuthScreen extends StatefulWidget {
  late final oauth2Url;
  late final oauth2RedirectUrl;

  SocialAuthScreen({required this.oauth2Url, required this.oauth2RedirectUrl});

  @override
  _SocialAuthScreenState createState() => _SocialAuthScreenState();
}

class _SocialAuthScreenState extends State<SocialAuthScreen> {
  late final WebViewController _controller;
  String? loginMessge=null;


  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (String url) {
        // 페이지 로딩 시작
      }, onPageFinished: (String url) {
        // 페이지 로딩 완료
      }, onNavigationRequest: (NavigationRequest request) async {
        TokenInfo provider = context.read<TokenInfo>();
        if (request.url.startsWith(widget.oauth2RedirectUrl)) {
          Uri url = Uri.parse(request.url);
          final response = await http.get(url);
          String? access = utf8.decode(response.bodyBytes);
          provider.saveAccessToken(access);
          if (access != null) {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => MyPage(data: 3, id: id, email: email, nickname: nickname),
            //     ));
            return NavigationDecision.prevent;
          }
        }
        // }else{
        //   if(request.url.startsWith("http://localhost:3000/token")){
        //     Uri url=Uri.parse(request.url);
        //     String? access=url.queryParameters['accesstoken'];
        //     provider.saveAccessToken(access);
        //     if(access!=null){
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => Dice(),
        //           ));
        //       return NavigationDecision.prevent;
        //     }
        //   }
        // }
        return NavigationDecision.navigate;
      }
      ))
      ..loadRequest(Uri.parse(widget.oauth2Url));
  }

  String? getCookieValue(String cookies, String key) {
    // 쿠키 문자열을 ';'로 분리
    final cookieList = cookies.split('; ');
    for (final cookie in cookieList) {
      // 키=값 형태를 '='로 분리
      if (cookie.startsWith('$key=')) {
        return cookie.split('=')[1]; // 키 뒤의 값을 반환
      }
    }
    return null; // 키가 없으면 null 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Authentication'),
      ),
      body: WebViewWidget(
        controller: _controller, // WebViewController 연결
      ),
    );
  }
}
