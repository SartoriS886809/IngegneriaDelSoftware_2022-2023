import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/core.dart';
import 'package:friendly_neighborhood/core/report/neighbours_reports.dart';
import 'package:friendly_neighborhood/core/report/my_reports.dart';
import 'package:friendly_neighborhood/core/report/create_report.dart';

//gli StatefulWidget devono essere gestiti con due classi, una per il widget ed una privata per lo stato
class ReportPage extends StatefulWidget {
  final NavigationBarCallback navCallback;
  final FloatingCallback fabCallback;

  const ReportPage(
      {super.key, required this.fabCallback, required this.navCallback});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final Map<String, IconData> pages = {
    "Segnalazioni": Icons.supervised_user_circle,
    "Mie segnalazioni": Icons.account_circle
  };

  final List<Widget> pagesWidgets = [
    const NeighboursReports(),
    const MyReports()
  ];
  late Widget _currentPage;
  late int _currentIndex;
  late final BottomNavigationBar bnb;
  late final FloatingActionButton _createNewReport;

  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    bnb = _createBottomNavigationBar();
    //TODO TEMPORANEO
    _currentPage = pagesWidgets[0];
    _createNewReport = FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreationReport()),
        );
      },
      label: const Text('Crea bisogno'),
      backgroundColor: Colors.orange[900],
    );

    //Il metodo viene invocato una volta finito il build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.navCallback(bnb);
      widget.fabCallback(_createNewReport);
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
      _currentPage = pagesWidgets[index];
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
          _currentIndex = value;
          _changeCurrentPage(value);
          //debug
          debugPrint(value.toString());
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
