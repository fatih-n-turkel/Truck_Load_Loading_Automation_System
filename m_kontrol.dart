import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ManuelKontrolSayfasi extends StatefulWidget {
  const ManuelKontrolSayfasi({super.key});

  @override
  State<ManuelKontrolSayfasi> createState() => _ManuelKontrolSayfasiState();
}

class _ManuelKontrolSayfasiState extends State<ManuelKontrolSayfasi> {
  final database = FirebaseDatabase.instance.reference();
  int istenenDepo = 0;

  String _displayText = "Veri Çekiliyor..";
  String _displayTextArac = "Veri Çekiliyor..";
  String _displayTextDepo = "Veri Çekiliyor..";
  String _displayTextOto = "Veri Çekiliyor..";
  String _displayTextIstenenDepo = "Veri Çekiliyor..";
  String _displayTextIstenenDepoDurum = "Veri Çekiliyor..";
  String _displayTextAracAgirligi = "Veri Çekiliyor..";
  final _database = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    _activateListenersServo();
    _activateListenersDistance();
    _activateListenersLoad();
    _activateListenersOto();
    _activateListenersIstenenDepo();
    _activateListenersIstenenDepoDurum();
    _activateListenersKantar();
  }

  void _activateListenersServo() {
    //final _descriptionRef = _database.child("dailySpecial/description");
    _database.child("Kontrol/Servo").onValue.listen((event) {
      final descriptionServo = event.snapshot.value.toString();
      setState(() {
        _displayText = "Sistem Durumu: $descriptionServo";
      });
    });
  }

  void _activateListenersDistance() {
    //final _descriptionRef = _database.child("dailySpecial/description");
    _database.child("dailySpecial/description").onValue.listen((event) {
      final description = event.snapshot.value.toString();
      setState(() {
        _displayTextArac = "Araç Durumu: $description";
      });
    });
  }

  void _activateListenersKantar() {
    //final _descriptionRef = _database.child("dailySpecial/description");
    _database.child("dailySpecial/kantar").onValue.listen((event) {
      final descriptionArac = event.snapshot.value.toString();
      setState(() {
        _displayTextAracAgirligi = "Araç Ağırlığı: $descriptionArac g";
      });
    });
  }

  void _activateListenersLoad() {
    //final _descriptionRef = _database.child("dailySpecial/description");
    _database.child("dailySpecial/depo").onValue.listen((event) {
      final descriptionDepo = event.snapshot.value.toString();
      setState(() {
        _displayTextDepo = "Depo Durumu: %$descriptionDepo";
      });
    });
  }

  void _activateListenersOto() {
    //final _descriptionRef = _database.child("dailySpecial/description");
    _database.child("dailySpecial/otomatik/otomatik").onValue.listen((event) {
      final descriptionOto = event.snapshot.value.toString();
      setState(() {
        _displayTextOto = "Otomatik Mod: $descriptionOto";
      });
    });
  }

  void _activateListenersIstenenDepo() {
    //final _descriptionRef = _database.child("dailySpecial/description");
    _database.child("dailySpecial/istenenDepo").onValue.listen((event) {
      final descriptionIstenenDepo = event.snapshot.value.toString();
      setState(() {
        _displayTextIstenenDepo =
            "İstenen Yük Miktarı: $descriptionIstenenDepo";
      });
    });
  }

  void _activateListenersIstenenDepoDurum() {
    //final _descriptionRef = _database.child("dailySpecial/description");
    _database.child("dailySpecial/istenenDepoDurum").onValue.listen((event) {
      final descriptionIstenenDepoDurum = event.snapshot.value.toString();
      setState(() {
        _displayTextIstenenDepoDurum =
            "İstenen Depo Durumu: $descriptionIstenenDepoDurum";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final dailySpecialRef = database.child("/dailySpecial");
    //final loadRef = database.child("/dailySpecial/depo");
    final kontrolServoRef = database.child("/Kontrol");
    final otoRef = database.child("/dailySpecial/otomatik");
    final istenenDepoRef = database.child("/dailySpecial/istenenDepo");
    final istenenDepoDurumRef =
        database.child("/dailySpecial/istenenDepoDurum");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text("Manuel Kontrol Paneli"),
      ),
      body: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 15,
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
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
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
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(1, 3))
                    ] // Make rounded corner of border
                    ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          border: Border.all(
                              color: Colors.grey.shade100, // Set border color
                              width: 3.0), // Set border width
                          borderRadius: const BorderRadius.all(Radius.circular(
                              10.0)), // Set rounded corner radius
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                          ),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              _displayTextArac,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                          Center(
                            child: Text(
                              _displayTextAracAgirligi,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                          Center(
                            child: Text(
                              _displayTextDepo,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                          Center(
                            child: Text(
                              _displayTextOto,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                          borderRadius: const BorderRadius.all(Radius.circular(
                              10.0)), // Set rounded corner radius
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                          ),
                      child: Column(
                        children: [
                          SizedBox(
                            child: Text(
                              _displayText,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Wrap(direction: Axis.vertical, children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  //horizontal: 100,
                                  ),
                              child: Row(children: [
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    onPressed: () async {
                                      try {
                                        await kontrolServoRef.set({
                                          'Servo': 'Acik',
                                        });
                                        await otoRef.set({
                                          'otomatik': 'Kapali',
                                        });
                                        print("Sistem Açık");
                                      } catch (e) {
                                        print("hata $e");
                                      }
                                    },
                                    child: const Text(
                                      "Kapağı Aç",
                                      style: TextStyle(color: Colors.black),
                                    )),
                                const SizedBox(
                                  width: 30,
                                ),
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    onPressed: () async {
                                      try {
                                        await kontrolServoRef
                                            .update({'Servo': 'Kapali'});
                                        await otoRef.update({
                                          'otomatik': 'Kapali',
                                        });

                                        print("Sistem Kapalı");
                                      } catch (e) {
                                        print("hata $e");
                                      }
                                    },
                                    child: const Text(
                                      "Kapağı Kapat",
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ]),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                          borderRadius: const BorderRadius.all(Radius.circular(
                              10.0)), // Set rounded corner radius
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                          ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 20.0, left: 20),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (String text) {
                                var myInt = int.parse(text);
                                assert(myInt is int);
                                istenenDepo = myInt;
                              },
                              decoration: InputDecoration(
                                //icon: const Icon(Icons.load),
                                labelText: 'İstediğiniz Yük Miktarı',

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
                            height: 10,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              onPressed: () async {
                                try {
                                  await istenenDepoDurumRef
                                      .update({'istenenDepoDurum': 1});
                                  await istenenDepoRef.update({
                                    'istenenDepo': istenenDepo,
                                  });
                                  await otoRef.set({
                                    'otomatik': 'Kapali',
                                  });
                                  Timer(const Duration(seconds: 6), () async {
                                    await istenenDepoDurumRef
                                        .update({'istenenDepoDurum': 0});
                                  });
                                  print("Sistem Kapalı");
                                } catch (e) {
                                  print("hata $e");
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      '$_displayTextIstenenDepo, araca yükleniyor..'),
                                ));
                              },
                              child: const Text(
                                "Araca Yükle",
                                style: TextStyle(color: Colors.black),
                              )),
                        ],
                      ),
                    ),

                    /*
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await database.update({'dailySpecial/price': 3.95});
                      } catch (e) {
                        print("yazı2 $e");
                      }
                    },
                    child: const Text("farklı"))*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
