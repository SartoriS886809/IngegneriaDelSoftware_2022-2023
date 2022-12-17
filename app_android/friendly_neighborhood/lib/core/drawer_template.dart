import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConstructDrawer extends StatelessWidget {
  late List<String> _routes;
  late String _currentRoute;
  ConstructDrawer(List<String> routes, String defaultRoute, {super.key}) {
    _routes = routes;
    _currentRoute = defaultRoute;
  }

  String get currentRoute => _currentRoute;
  void changeCurrentRoute(String route) {
    _currentRoute = route;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: _routes.length+1,
        itemBuilder: (context, index) {
          if(index==0){
            return DrawerHeader(
              child:Row(
                children: const [
                  Expanded(child:Text("(logo)")),
                  Expanded(child:
                  Text("Friendly Neighborhood")
                  )
                ],
              )
              //decoration: 
              //child: Text('Drawer Header'),
            );
          }else{
            final value = _routes.elementAt(index-1);
            return ListTile(
              title: Text(value),
              onTap: () {
                _currentRoute = value;
                Navigator.pop(context);
              },
            );
          }
        },
      ));


      /*  child: ListView.builder(
      itemCount: _routes.length,
      itemBuilder: (context, index) {
        final value = _routes.elementAt(index);
        return ListTile(
          title: Text(value),
          onTap: () {
            _currentRoute = value;
            Navigator.pop(context);
          },
        );
      },
    ));*/
  }
}
