import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/core.dart';

//gli StatefulWidget devono essere gestiticon due classi, una per il widget ed una privata per lo stato
class ServicePage extends StatefulWidget {
  final NavigationBarCallback navCallback;

  const ServicePage({super.key, required this.navCallback});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final Map<String, IconData> pages = {
    "Servizi": Icons.supervised_user_circle,
    "Miei servizi": Icons.account_circle
  };
  late Widget _currentPage;

  late final BottomNavigationBar bnb;

  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
    bnb = _createBottomNavigationBar();
    //TODO TEMPORANEO
    _currentPage = const Text("ciao");
    //Il metodo viene invocato una volta finito il build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.navCallback(bnb);
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
        onTap: (value) {
          //VALUE => 0 o 1
          _changeCurrentPage(value);
        },
        items: _createListBNB(pages));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_currentPage],
    );
  }
}
