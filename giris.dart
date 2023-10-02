import 'dart:async';

import 'package:bitirme_projesi_23/arayuz/ana_sayfa.dart';
import 'package:bitirme_projesi_23/arayuz/proje_bilgisi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://flutter.dev');

class Giris extends StatefulWidget {
  const Giris({super.key});

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  bool _isObscure = true;
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
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text(
          "FATİH NAİM TÜRKEL\n     201813151041",
          style: TextStyle(),
        ),
      ),
      body: Center(
          child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Wrap(
              spacing: 8.0, // gap between adjacent chips
              runSpacing: 4.0, // gap between lines
              direction: Axis.vertical,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 74,
                        width: 74,
                        child: Image.asset(
                          'lib/images/dpulogo.png',
                          fit: BoxFit.fill,
                        )),
                    const SizedBox(
                      width: 4,
                    ),
                    const SizedBox(
                      child: Text(
                          "KÜTAHYA DUMLUPINAR ÜNİVERSİTESİ\nELEKTRİK-ELEKRTONİK MÜHENDİSLİĞİ\n     MİCROSENSOR ANALYSİS DERSİ"),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset('lib/images/dpumuhlogo.jpg',
                            fit: BoxFit.fill)),
                  ],
                ),
              ]),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                border: Border.all(
                    color: Colors.grey.shade100, // Set border color
                    width: 3.0), // Set border width
                borderRadius: const BorderRadius.all(
                    Radius.circular(10.0)), // Set rounded corner radius
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
                ] // Make rounded corner of border
                ),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "YÜK DOLDURMA OTOMASYON",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                const Center(
                  child: Text(
                    "SİSTEMİ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Center(
                  child: Text(
                    "GİRİŞ EKRANI",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: TextFormField(
                    onChanged: (String text) {
                      email = text;
                    },
                    decoration: InputDecoration(
                      icon: const Icon(Icons.mail),
                      labelText: 'mail',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: TextFormField(
                    obscureText: _isObscure,
                    onChanged: (String text) {
                      password = text;
                    },
                    decoration: InputDecoration(
                      icon: const Icon(Icons.password),
                      labelText: 'şifre',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () async {
                      loginUserEmailAndPassword();
                      Timer(const Duration(seconds: 2), () {
                        if (auth.currentUser == null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Böyle bir kullanıcı yok!'),
                          ));
                        } else {
                          signOutUser();
                          kontrol();
                        }
                      });
                    },
                    child: const Text(
                      "Giriş",
                      style: TextStyle(color: Colors.black),
                    )),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            child: const Text(
                "Proje hakkında daha fazla bilgi edinebilmek için tıklayınız"),
            //onTap: _launchUrl,
            onTap: () {
              Navigator.of(context)
                  //.push(MaterialPageRoute(builder: (context) => Deneme()));
                  //.push(MaterialPageRoute(builder: (context) => Dddeneme()));
                  .push(MaterialPageRoute(
                      builder: (context) => const ProjeBilgisi()));
            },
          )
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

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
