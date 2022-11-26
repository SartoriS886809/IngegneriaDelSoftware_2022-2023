import 'package:flutter/material.dart';

typedef CoreCallback = void Function(String route);

class DashBoard extends StatelessWidget {
  final CoreCallback switchBody;
  final List<String> routes;
  const DashBoard({super.key, required this.switchBody, required this.routes});

  @override
  Widget build(BuildContext context) {
    List<String> routesFiltered = [...routes];
    routesFiltered.removeAt(0);
    return Stack(children: [
      ListView.builder(
        itemCount: routesFiltered.length,
        itemBuilder: (context, index) {
          return ElevatedButton(
            onPressed: () {
              switchBody(routesFiltered[index]);
            },
            child: Text(routesFiltered[index]),
          );
        },
      )
    ]);
  }
}
/*

Column(children: [
      const Text("Hello Dashboard"),
      TextButton(
        child: const Text("cambia schermata"),
        onPressed: () {
          switchBody("Profilo");
        },
      )
    ])
*/