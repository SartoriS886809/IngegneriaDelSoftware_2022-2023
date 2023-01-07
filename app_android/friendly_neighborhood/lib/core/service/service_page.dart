// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/core.dart';
import 'package:friendly_neighborhood/core/service/create_modify_service.dart';
import 'package:friendly_neighborhood/core/service/my_service.dart';
import 'package:friendly_neighborhood/core/service/neighborhood_service.dart';

//gli StatefulWidget devono essere gestiti con due classi, una per il widget ed una privata per lo stato

/*
* Classe ServicePage:
* La seguente classe corrisponde ad uno dei moduli dell'applicazione. Si occupa della navigazione
* tra le sotto schermate e mette a disposizione una bottom navigation bar e un floating action button.
*/
class ServicePage extends StatefulWidget {
  final NavigationBarCallback navCallback;
  final FloatingCallback fabCallback;

  const ServicePage(
      {super.key, required this.navCallback, required this.fabCallback});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  //Definizione delle route
  final Map<String, IconData> pages = {
    "Servizi": Icons.supervised_user_circle,
    "Miei servizi": Icons.account_circle
  };
  late Widget _currentPage;
  late int _currentIndex;
  late final FloatingActionButton _createNewService;

  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _changeCurrentPage(_currentIndex);
    _createNewService = FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CreationOrModificationService()),
        ).then(
          (value) {
            setState(() {
              _changeCurrentPage(_currentIndex);
            });
          },
        );
      },
      label: const Text('Crea servizio'),
      backgroundColor: Colors.orange[900],
    );
    //Il metodo viene invocato una volta finito il build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.navCallback(_createBottomNavigationBar());
      widget.fabCallback(_createNewService);
    });
  }

/*
* funzione _createListBNB
* la seguente funzione si occupa di generare in modo dinamico i pulsanti per la bottom navigation bar
* in base alle route create
*/
  List<BottomNavigationBarItem> _createListBNB(
      Map<String, IconData> pagesList) {
    List<BottomNavigationBarItem> l = [];
    for (MapEntry<String, IconData> s in pagesList.entries) {
      l.add(BottomNavigationBarItem(label: s.key, icon: Icon(s.value)));
    }
    return l;
  }

/*
* funzione _changeCurrentPage
* la seguente funzione si occupa di cambiare e generare la pagina corrente in base all'indice
* passato per parametro
*/
  void _changeCurrentPage(int index) {
    _currentPage = Container();
    if (index == 0) {
      _currentPage = NeighborhoodServicePage();
    } else if (index == 1) {
      _currentPage = MyServicePage();
    } else {
      throw "Not Implemented";
    }
    setState(() {});
  }

/*
* funzione _createBottomNavigationBar
* la seguente funzione si occupa di generare  la bottom navigation bar
*/
  BottomNavigationBar _createBottomNavigationBar() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF6200EE),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
          _changeCurrentPage(value);
          widget.navCallback(_createBottomNavigationBar());
        },
        items: _createListBNB(pages));
  }

  @override
  Widget build(BuildContext context) {
    return _currentPage;
  }
}
