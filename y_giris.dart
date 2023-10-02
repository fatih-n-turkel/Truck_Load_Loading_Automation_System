import 'dart:async';

import 'package:bitirme_projesi_23/arayuz/ana_sayfa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class YGiris extends StatefulWidget {
  const YGiris({super.key});

  @override
  State<YGiris> createState() => _YGirisState();
}

class _YGirisState extends State<YGiris> {
  late FirebaseAuth auth;
  String email = '';
  String password = '';
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User oturumu kapalı');
      } else {
        debugPrint(
            'User oturum açık ${user.email} ve email durumu ${user.emailVerified}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FATİH NAİM TÜRKEL\n201813151041",
          style: TextStyle(),
        ),
      ),
      body: Center(
          child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            onChanged: (String text) {
              email = text;
            },
            decoration: const InputDecoration(
              hintText: 'mail',
            ),
          ),
          TextFormField(
            onChanged: (String text) {
              password = text;
            },
            decoration: const InputDecoration(
              hintText: 'şifre',
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                loginUserEmailAndPassword();
                Timer(const Duration(seconds: 2), () {
                  if (auth.currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Böyle bir kullanıcı yok!'),
                    ));
                  } else {
                    signOutUser();
                    kontrol();
                  }
                });
              },
              child: const Text("Giriş")),
          const SizedBox(
            height: 30,
          ),
          /*
          ElevatedButton(
              onPressed: () {
                signOutUser();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Çıkış Yapıldı!'),
                ));
              },
              child: const Text("Çıkış")),
              const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                signOutUser();
                kontrol();
              },
              child: const Text("Menü")),*/
        ],
      )),
    );
  }

  void loginUserEmailAndPassword() async {
    try {
      var userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      debugPrint(userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void signOutUser() async {
    var user = GoogleSignIn().currentUser;
    if (user != null) {
      await GoogleSignIn().signOut();
    }
    await auth.signOut();
  }

  void kontrol() {
    if (auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Lütfen giriş yapınız!'),
      ));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const AnaSayfa()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Hoşgeldiniz'),
      ));
    }
  }
}
