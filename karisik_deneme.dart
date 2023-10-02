import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class KDeneme extends StatefulWidget {
  const KDeneme({super.key});

  @override
  State<KDeneme> createState() => _KDenemeState();
}

class _KDenemeState extends State<KDeneme> {
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

  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      DatabaseReference _test =
          FirebaseDatabase.instance.reference().child("test");
      _counter++;
      _test.set(_counter);


    });
  }

  @override
  Widget build(BuildContext context) {
final dailySpecialRef = database.child("/dailySpecial");

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("ÖRNEK 1"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tıkladıkça veritabanına tıklanma miktarı gidecek. Tıklanma sayısı:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20,),
            Padding(
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
