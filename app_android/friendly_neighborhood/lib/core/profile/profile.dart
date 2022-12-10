import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/profile/modify_profile.dart';
import 'package:friendly_neighborhood/first_page/login_screen.dart';
import 'package:friendly_neighborhood/model/localuser.dart';

import '../dashboard/dashboard.dart';

class Profile extends StatefulWidget {
  final CoreCallback switchBody;
  const Profile({super.key, required this.switchBody});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late LocalUser? user;
  final LocalUserManager luManager = LocalUserManager();

  Future<Widget> _asyncBuilder(BuildContext context) async {
    /*TODO Temporaneo, da rimuovere con login
    LocalUser ut = LocalUser(
        "ciao@ciao.com",
        "Pucci",
        "Enrico",
        "Pucci",
        DateTime.now(),
        "via Asseggiano",
        1,
        "Casa Singola",
        "Dorsoduro",
        "1r2asdasdsad");
    
    await luManager.insertUser(ut);
    */
    user = await luManager.getUser();
    if (user == null) {
      return Column(
        children: [
          const Text("Errore interno, si prega di rieseguire il login"),
          TextButton(
              onPressed: (() {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }),
              child: const Text("Ritorna alla pagina di login"))
        ],
      );
    }
    return Column(
      children: [
        const Text("Il tuo profilo:"),
        Text("Email: ${user!.email}"),
        Text("Nome: ${user!.name}"),
        Text("Cognome: ${user!.lastname}"),
        Text(
            "Data di nascita: ${user!.birth_date.day}-${user!.birth_date.month}-${user!.birth_date.year}"),
        Text("Indirizzo: ${user!.address}"),
        Text("Nucleo familiare: ${user!.family}"),
        Text("Tipologia abitazione: ${user!.house_type}"),
        Text("Quartiere: ${user!.neighborhood}"),
        Container(
          height: 50,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                widget.switchBody("Dashboard");
              },
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text('Vai alla dashboard'),
              )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModifyProfile(user: user!)))
                    .then((value) => setState(() {}));
              },
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text('Modifica profilo'),
              )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                //TODO Eseguire operazione di logout
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text('Disconnetti'),
              )),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: _asyncBuilder(context),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
