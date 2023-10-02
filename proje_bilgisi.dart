import 'package:flutter/material.dart';

class ProjeBilgisi extends StatelessWidget {
  const ProjeBilgisi({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(70.0),
        child: SingleChildScrollView(
            child: Wrap(
              children: [Column(
                      children: [
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/1.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/2.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/3.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/4.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/5.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/6.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/7.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/8.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/9.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/10.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/11.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/12.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/13.png',
                // fit: BoxFit.fill,
              )),
              SizedBox(
                  //height: 74,
                  //width: 74,
                  child: Image.asset(
                'lib/images/14.png',
                // fit: BoxFit.fill,
              )),
                      ],
                    ),]
            )),
      ),
    );
  }
}
