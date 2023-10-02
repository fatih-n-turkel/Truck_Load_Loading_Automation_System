import 'package:bitirme_projesi_23/arayuz/m_kontrol.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final database = FirebaseDatabase.instance.reference();
  String _displayTextOto = "Veri Çekiliyor..";
  final _database = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    _activateListenersOto();
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
  @override
  Widget build(BuildContext context) {
    final otoRef = database.child("/dailySpecial/otomatik");
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            "BİTİRME 23 PROJESİ",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
        ),
        body: Container(
          child: Column(children: [
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
              height: 130,
            ),
            const Center(
              child: Text(
                "Sistemi hangi modda",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            const Center(
              child: Text(
                "çalıştırmak istiyorsunuz?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        //.push(MaterialPageRoute(builder: (context) => Deneme()));
                        //.push(MaterialPageRoute(builder: (context) => Dddeneme()));
                        .push(MaterialPageRoute(
                            builder: (context) =>
                                const ManuelKontrolSayfasi()));
                  },
                  child: const Text("MANUEL KONTROL"),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () async{
                    try {
                                
                                    await otoRef.update({
                                  'otomatik': 'Acik',
                                });
                                print("Oto Sistem Acik");
                              } catch (e) {
                                print("hata $e");
                              }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Otomatik Moda Geçildi!'),
                    ));
                  },
                  child: const Text("OTOMATİK KONTROL"),
                ),
              ],
            ),
          ]),
        ));
  }
}
