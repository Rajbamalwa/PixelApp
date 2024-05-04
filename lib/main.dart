import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixelsvibe/provider/saveDataProvider.dart';
import 'package:provider/provider.dart';
import 'Services/Api.dart';
import 'Views/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Views/Login.dart';
//Main

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CallApi()),
        ChangeNotifierProvider(create: (_) => SaveDataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pixels Vibe',
        themeMode: ThemeMode.dark,
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: user == null ? LoginView() : const HomePage(),
      ),
    );
  }
}
