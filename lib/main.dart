import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'main_page.dart';
import 'loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  KakaoSdk.init(
    nativeAppKey:  dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? 'Not Found : KAKAO_NATIVE_APP_KEY', // '${KAKAO_NATIVE_APP_KEY}',
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT_APP_KEY'] ?? 'Not Found : KAKAO_JAVASCRIPT_APP_KEY' // '${YOUR_JAVASCRIPT_APP_KEY}',
  );

  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 252, 164, 114), // #FCA472 상태바 색상 적용
    statusBarIconBrightness: Brightness.light, // 상태바 아이콘 색상 (light → 흰색)
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: LoadingPage(
      ),
      // routes 영역
      );
  }
}

class MyHomePage {
  const MyHomePage();
}
