import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Dddeneme extends StatefulWidget {
  const Dddeneme({super.key});

  @override
  State<Dddeneme> createState() => _DddenemeState();
}

class _DddenemeState extends State<Dddeneme> {
  final database = FirebaseDatabase.instance.reference();

  String _displayText = "Results go here";
  final _database = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    //final _descriptionRef = _database.child("dailySpecial/description");
    _database.child("dailySpecial/description").onValue.listen((event) {
      final description = event.snapshot.value.toString();
      setState(() {
        _displayText = "içecek: $description";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final dailySpecialRef = database.child("/dailySpecial");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Başlık"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await dailySpecialRef
                          .set({'description': 'Vanilla latte', 'price': 4.99});
                      print("yazı1");
                    } catch (e) {
                      print("yazı2 $e");
                    }
                  },
                  child: 
                  Text("yazı $_displayText")),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await dailySpecialRef.update(
                          {'description': 'mocha', 'price': 2.50});
                      print("yazı1");
                    } catch (e) {
                      print("yazı2 $e");
                    }
                  },
                  child: const Text("güncel")),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await database.update({'dailySpecial/price': 3.95});
                    } catch (e) {
                      print("yazı2 $e");
                    }
                  },
                  child: const Text("farklı"))
            ],
          ),
        ),
      ),
    );
  }
}
