import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'arayuz/m_kontrol.dart';
import 'firebase_options.dart';
import 'giris/giris.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitirme 23',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Giris(),
      //home: const ManuelKontrolSayfasi(),
      debugShowCheckedModeBanner: false,
    );
  }
}
