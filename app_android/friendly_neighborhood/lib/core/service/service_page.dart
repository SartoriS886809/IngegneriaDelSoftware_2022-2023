import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/core.dart';
import 'package:friendly_neighborhood/core/service/create_modify_service.dart';
import 'package:friendly_neighborhood/core/service/my_service.dart';
import 'package:friendly_neighborhood/core/service/neighborhood_service.dart';

//gli StatefulWidget devono essere gestiticon due classi, una per il widget ed una privata per lo stato
class ServicePage extends StatefulWidget {
  final NavigationBarCallback navCallback;
  final FloatingCallback fabCallback;

  const ServicePage(
      {super.key, required this.navCallback, required this.fabCallback});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
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

  List<BottomNavigationBarItem> _createListBNB(
      Map<String, IconData> pagesList) {
    List<BottomNavigationBarItem> l = [];
    for (MapEntry<String, IconData> s in pagesList.entries) {
      l.add(BottomNavigationBarItem(label: s.key, icon: Icon(s.value)));
    }
    return l;
  }

  //Cambia la pagina visualizzata in base al indice
  void _changeCurrentPage(int index) {
    if (index == 0) {
      _currentPage = const NeighborhoodServicePage();
    } else if (index == 1) {
      _currentPage = const MyServicePage();
    } else {
      throw "Not Implemented";
    }
    setState(() {});
  }

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
