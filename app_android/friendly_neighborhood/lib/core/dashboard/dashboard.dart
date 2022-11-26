import 'package:flutter/material.dart';

typedef CoreCallback = void Function(String route);

class DashBoard extends StatelessWidget {
  final CoreCallback switchBody;
  const DashBoard({super.key, required this.switchBody});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Hello Dashboard"),
      TextButton(
        child: const Text("cambia schermata"),
        onPressed: () {
          switchBody("Profilo");
        },
      )
    ]);
  }
}
