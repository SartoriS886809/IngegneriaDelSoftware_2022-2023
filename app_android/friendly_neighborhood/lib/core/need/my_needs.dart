import 'package:flutter/material.dart';

class MyNeeds extends StatefulWidget {

  const MyNeeds({super.key});

  @override
  State<MyNeeds> createState() => _MyNeedsState();
}

class _MyNeedsState extends State<MyNeeds> {

  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text("my needs");
  }
}
