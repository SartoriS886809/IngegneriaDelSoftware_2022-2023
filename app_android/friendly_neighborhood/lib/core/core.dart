import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/dashboard/dashboard.dart';
import 'package:friendly_neighborhood/core/drawer_template.dart';
import 'package:friendly_neighborhood/core/need/need_page.dart';
import 'package:friendly_neighborhood/core/profile/profile.dart';
import 'package:friendly_neighborhood/core/report/report_page.dart';
import 'package:friendly_neighborhood/core/service/service_page.dart';

typedef NavigationBarCallback = void Function(BottomNavigationBar bnb);
typedef FloatingCallback = void Function(FloatingActionButton fab);
typedef DownloadNewDataFunction = void Function(bool refreshWidget);

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
  final List<Icon> _icons = [
    const Icon(Icons.home),
    const Icon(Icons.announcement),
    const Icon(Icons.assignment),
    const Icon(Icons.business_center_rounded),
    const Icon(Icons.account_circle),
  ];

  late Widget _openPage;
  late BottomNavigationBar? _bottomNavbar;
  late FloatingActionButton? _floatingButton;

  @override
  void initState() {
    super.initState();
    _currentPage = _routes[0];
    _drawer = ConstructDrawer(_routes, _currentPage, _icons);
    _openPage = _getBodyPage(_currentPage);
    _bottomNavbar = null;
  }

  void _switchManualBody(String newRoute) {
    setState(() {
      _openPage = _getBodyPage(newRoute);
      _currentPage = newRoute;
      _drawer.changeCurrentRoute(_currentPage);
    });
  }

  void _setNavigationBar(BottomNavigationBar? bnb) {
    setState(() {
      _bottomNavbar = bnb;
    });
  }

  void _setFloatingButton(FloatingActionButton? fab) {
    setState(() {
      _floatingButton = fab;
    });
  }

  //Genera la pagina da cambiare
  Widget _getBodyPage(String newRoute) {
    switch (newRoute) {
      case "Dashboard":
        _setNavigationBar(null);
        _setFloatingButton(null);
        return DashBoard(
            switchBody: (String route) => _switchManualBody(route),
            routes: _routes);
      case "Segnalazioni":
        _setFloatingButton(null);
        return ReportPage(
            navCallback: ((bnb) => _setNavigationBar(bnb)),
            fabCallback: ((fab) => _setFloatingButton(fab)));
      case "Bisogni":
        _setFloatingButton(null);
        return NeedPage(
            navCallback: ((bnb) => _setNavigationBar(bnb)),
            fabCallback: ((fab) => _setFloatingButton(fab)));
      case "Servizi":
        return ServicePage(
            navCallback: ((bnb) => _setNavigationBar(bnb)),
            fabCallback: ((fab) => _setFloatingButton(fab)));
      case "Profilo":
        _setNavigationBar(null);
        _setFloatingButton(null);
        return Profile(switchBody: (String route) => _switchManualBody(route));
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _floatingButton,
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
