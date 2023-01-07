// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

/*
* Classe ConstructDrawer:
* La seguente classe gestisce il drawer per la navigazione tra le varie schermate dell'applicazione
*/
class ConstructDrawer extends StatelessWidget {
  late List<String> _routes;
  late List<Icon> _icons;
  late String _currentRoute;
  ConstructDrawer(List<String> routes, String defaultRoute, List<Icon> icons,
      {super.key}) {
    _routes = routes;
    _currentRoute = defaultRoute;
    _icons = icons;
  }

  String get currentRoute => _currentRoute;
  void changeCurrentRoute(String route) {
    _currentRoute = route;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView.builder(
      itemCount: _routes.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return DrawerHeader(
              child: Row(
            children: const [
              Expanded(
                  child: SizedBox(
                      child: Image(
                image: AssetImage('assets/app_icon.png'),
                width: 100,
                height: 100,
              ))),
              Expanded(child: Text("Friendly Neighborhood"))
            ],
          ));
        } else {
          final value = _routes.elementAt(index - 1);
          return ListTile(
            title: Text(value),
            trailing: _icons.elementAt(index - 1),
            onTap: () {
              _currentRoute = value;
              Navigator.pop(context);
            },
          );
        }
      },
    ));
  }
}
