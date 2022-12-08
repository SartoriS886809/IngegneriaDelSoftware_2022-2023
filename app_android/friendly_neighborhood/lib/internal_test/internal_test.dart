import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/model/neighborhood.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  Future<Widget> testNeighborhoods() async {
    List<Neighborhood> l = await API_Manager.getNeighborhoods();
    String s = "";
    for (Neighborhood n in l) {
      s += "${n}, ";
    }
    return Text(s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //TEST NEIGHBORHOOD
          FutureBuilder<Widget>(
              future: testNeighborhoods(),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const Text("Reciving data...");
                }
              })
        ],
      ),
    );
  }
}
