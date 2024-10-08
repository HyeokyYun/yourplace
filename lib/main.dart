import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:yourplace/controller/chat_controller.dart';
import 'package:yourplace/firebase_options.dart';
import 'package:yourplace/providers/character_image_path_provider.dart';
import 'package:yourplace/providers/user_provider.dart';
import 'package:yourplace/screen/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // kakao login
  KakaoSdk.init(
    nativeAppKey: '3d15f82426b2820c143667ef010cdffc',
    javaScriptAppKey: '0253b4e47ab26d32e8251894a48c2f43',
  );

  // firebase logins
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ChatController()),
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => CharacterImagePathProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YOUR PLACE V1',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: SplashScreen(),
    );
  }
}
