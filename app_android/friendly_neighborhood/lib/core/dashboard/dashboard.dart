import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/model/localuser.dart';

typedef CoreCallback = void Function(String route);

class DashBoard extends StatelessWidget {
  final CoreCallback switchBody;
  final List<String> routes;
  const DashBoard({super.key, required this.switchBody, required this.routes});

  Future<Widget> _asyncBuilder(BuildContext context) async {
    List<String> routesFiltered = [...routes];
    routesFiltered.removeAt(0);
    LocalUserManager lum = LocalUserManager();
    LocalUser? user = await lum.getUser();
    return Stack(children: [
      ListView.builder(
        itemCount: routesFiltered.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
                padding: const EdgeInsets.all(10),
                child: (Text.rich(TextSpan(
                    text: "Benvenuto, ${user?.username}",
                    style: Theme.of(context).textTheme.headline6))));
          } else {
            return ElevatedButton(
              onPressed: () {
                switchBody(routesFiltered[index - 1]);
              },
              child: Text(routesFiltered[index - 1]),
            );
          }
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    List<String> routesFiltered = [...routes];
    routesFiltered.removeAt(0);
    //LocalUserManager lum = LocalUserManager();
    //LocalUser? user=await lum.getUser();
    /*return Stack(children: [
      ListView.builder(
        itemCount: routesFiltered.length+1,
        itemBuilder: (context, index) {
          if(index==0) //return Container(height: 5);
          return Padding(
            padding: EdgeInsets.all(5),
            child:(Text.rich(TextSpan(text:"Ciao ")))
          );
          else 
          return ElevatedButton(
            onPressed: () {
              switchBody(routesFiltered[index-1]);
            },
            child: Text(routesFiltered[index-1]),
          );
        },
      )
    ]);*/
    return FutureBuilder<Widget>(
        future: _asyncBuilder(context),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
