import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/core.dart';
import 'package:friendly_neighborhood/core/need/my_assignments.dart';
import 'package:friendly_neighborhood/core/need/neighbours_needs.dart';
import 'package:friendly_neighborhood/core/need/my_needs.dart';


//gli StatefulWidget devono essere gestiti con due classi, una per il widget ed una privata per lo stato
class NeedPage extends StatefulWidget {
  final NavigationBarCallback navCallback;

  const NeedPage({super.key, required this.navCallback});

  @override
  State<NeedPage> createState() => _NeedPageState();
}

class _NeedPageState extends State<NeedPage> {
  final Map<String, IconData> pages = {
    "Richieste": Icons.supervised_user_circle,
    "Mie richieste": Icons.account_circle,
    "Miei incarichi": Icons.assignment_turned_in
  };
  //TODO mappare insieme su pages anche le pagine
  final List<Widget> pagesWidgets= [const NeighboursNeeds(), const MyNeeds(), const MyAssignments()];

  late Widget _currentPage;
  late int _currentIndex;
  late final BottomNavigationBar bnb;

  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
    _currentIndex=0;
    bnb = _createBottomNavigationBar();
    //TODO TEMPORANEO
    //_currentPage = const Text("ciao");
    _currentPage=pagesWidgets[0];
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
    setState(() {
      _currentPage=pagesWidgets[index];
    });
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
          //VALUE => 0 o 1
          _currentIndex=value;
          _changeCurrentPage(value);
          widget.navCallback(_createBottomNavigationBar());
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
