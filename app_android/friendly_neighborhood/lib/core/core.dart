import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/dashboard/dashboard.dart';
import 'package:friendly_neighborhood/core/drawer_template.dart';

class Core extends StatefulWidget {
  const Core({super.key});

  @override
  State<Core> createState() => _CoreState();
}

class _CoreState extends State<Core> {
  late String _currentPage;
  late ConstructDrawer _drawer;
  final List<String> _routes = [
    "Dashboard",
    "Segnalazioni",
    "Bisogni",
    "Servizi",
    "Profilo"
  ];
  late Widget _openPage;

  @override
  void initState() {
    super.initState();
    _currentPage = _routes[0];
    _drawer = ConstructDrawer(_routes, _currentPage);
    _openPage = _getBodyPage(_currentPage);
  }

  void switchManualBody(String newRoute) {
    setState(() {
      _openPage = _getBodyPage(newRoute);
      _currentPage = newRoute;
    });
  }

  //Genera la pagina da cambiare
  Widget _getBodyPage(String newRoute) {
    switch (newRoute) {
      case "Dashboard":
        return DashBoard(
            switchBody: (String route) => switchManualBody(route),
            routes: _routes);
      case "Segnalazioni":
        return const Text("Segnalazioni");
      case "Bisogni":
        return const Text("Bisogni");
      case "Servizi":
        return const Text("Servizi");
      case "Profilo":
        return const Text("Profilo");
      default:
        return const Text("Errore");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPage),
      ),
      drawer: _drawer,
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          if (_currentPage != _drawer.currentRoute) {
            //Se la pagina è cambiata allora aggiorno la schermata
            setState(() {
              _currentPage = _drawer.currentRoute;
              _openPage = _getBodyPage(_drawer.currentRoute);
            });
          }
        }
      },
      body: _openPage,
    );
  }
}
