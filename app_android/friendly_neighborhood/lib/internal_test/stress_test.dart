import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/internal_test/internal_test.dart';

/*
* Classe StressTest:
* La seguente classe esegue dei stress test sul server
*/
class StressTest extends StatefulWidget {
  const StressTest({super.key});

  @override
  State<StressTest> createState() => _StressTestState();
}

class _StressTestState extends State<StressTest> {
  String result = "";
  bool started = false;

/*
* funzione stressTestNeighborhoods
* Esegue il download dei vari neighborhoods 5000 volte
*/
  void stressTestNeighborhoods() async {
    if (started) return;
    started = true;
    setState(() {
      result = "Test iniziato";
    });
    try {
      for (int j = 0; j < 10; j++) {
        for (int i = 0; i < 5000; i++) {
          API_Manager.getNeighborhoods();
          sleep(const Duration(microseconds: 5));
        }
        sleep(const Duration(seconds: 1));
      }
    } catch (e) {
      started = false;
      setState(() {
        result = "Errore";
      });
    }
    setState(() {
      result = "Test completato";
    });
    started = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Stress test su neighborhoods: $result"),
          TextButton(
              onPressed: (() => stressTestNeighborhoods()),
              child: const Text("Avvia")),
          TextButton(
              onPressed: (() {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Test()));
              }),
              child: const Text("Vai a test di funzioni")),
        ],
      ),
    );
  }
}
