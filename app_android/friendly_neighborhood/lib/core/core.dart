import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/dashboard/dashboard.dart';
import 'package:friendly_neighborhood/core/drawer_template.dart';
import 'package:friendly_neighborhood/core/need/need_page.dart';
import 'package:friendly_neighborhood/core/report/report_page.dart';
import 'package:friendly_neighborhood/core/service/service_page.dart';

typedef NavigationBarCallback = void Function(BottomNavigationBar bnb);

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
  late BottomNavigationBar? _bottomNavbar;

  @override
  void initState() {
    super.initState();
    _currentPage = _routes[0];
    _drawer = ConstructDrawer(_routes, _currentPage);
    _openPage = _getBodyPage(_currentPage);
    _bottomNavbar = null;
  }

  void _switchManualBody(String newRoute) {
    setState(() {
      _openPage = _getBodyPage(newRoute);
      _currentPage = newRoute;
    });
  }

  void _setNavigationBar(BottomNavigationBar? bnb) {
    setState(() {
      _bottomNavbar = bnb;
    });
  }

  //Genera la pagina da cambiare
  Widget _getBodyPage(String newRoute) {
    switch (newRoute) {
      case "Dashboard":
        _setNavigationBar(null);
        return DashBoard(
            switchBody: (String route) => _switchManualBody(route),
            routes: _routes);
      case "Segnalazioni":
        return ReportPage(navCallback: ((bnb) => _setNavigationBar(bnb)));
      case "Bisogni":
        return NeedPage(navCallback: ((bnb) => _setNavigationBar(bnb)));
      case "Servizi":
        return ServicePage(navCallback: ((bnb) => _setNavigationBar(bnb)));
      case "Profilo":
        _setNavigationBar(null);
        return const Text("Profilo");
      default:
        return const Text("Errore interno");
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
      bottomNavigationBar: _bottomNavbar,
      body: _openPage,
    );
  }
}
