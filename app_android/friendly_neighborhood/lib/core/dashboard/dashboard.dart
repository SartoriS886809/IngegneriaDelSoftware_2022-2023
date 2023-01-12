import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/model/localuser.dart';

//Funzioni per callback
typedef CoreCallback = void Function(String route);

/*
* Classe DashBoard:
* La seguente classe si occupa di generare l'interfaccia del menù per la navigazione
*/
class DashBoard extends StatelessWidget {
  final CoreCallback switchBody;
  final List<String> routes;

  const DashBoard({super.key, required this.switchBody, required this.routes});

/*
* funzione _asyncBuilder
* la seguente funzione si occupa di generare la pagina una volta completate le operazioni
* di caricamento dei dati
*/
  Future<Widget> _asyncBuilder(BuildContext context) async {
    List<Icon> icons = [
      const Icon(Icons.announcement),
      const Icon(Icons.assignment),
      const Icon(Icons.business_center_rounded),
      const Icon(Icons.account_circle),
      const Icon(Icons.help)
    ];
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
            return Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton.icon(
                      icon: icons[index - 1],
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(250, 60)),
                      onPressed: () {
                        switchBody(routesFiltered[index - 1]);
                      },
                      label: Center(child: Text(routesFiltered[index - 1])),
                    )));
          }
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    List<String> routesFiltered = [...routes];
    routesFiltered.removeAt(0);
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
