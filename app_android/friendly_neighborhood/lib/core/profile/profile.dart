// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/profile/modify_profile.dart';
import 'package:friendly_neighborhood/first_page/login_screen.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/utils/alertdialog.dart';

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

  void logout() async {
    await luManager.deleteUser(user!);
    await API_Manager.logout(user!.email);
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void deleteAccount() async {
    await luManager.deleteUser(user!);
    await API_Manager.deleteAccount(user!.token);
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<Widget> _asyncBuilder(BuildContext context) async {
    user = await luManager.getUser();
    if (user == null) {
      return Column(
        children: [
          const Text("Errore interno, si prega di rieseguire il login"),
          TextButton(
              onPressed: (() {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }),
              child: const Text("Ritorna alla pagina di login"))
        ],
      );
    }
    
    return ListView(
    //return Column(
      children: [
        //const Text("Il tuo profilo:"),
        ListTile(title: Text("Username"),subtitle:Text(user!.username)),
        ListTile(title: Text("E-mail"),subtitle:Text(user!.email)),
          //Text("Email: ${user!.email}"),
        ListTile(title: Text("Nome"),subtitle:Text(user!.name)),  
          //Text("Nome: ${user!.name}"),
        ListTile(title: Text("Cognome"),subtitle:Text(user!.lastname)),
          //Text("Cognome: ${user!.lastname}"),
        ListTile(title: Text("Data di nascita"),subtitle:Text("${user!.birth_date.day}-${user!.birth_date.month}-${user!.birth_date.year}")),  
          //Text("Data di nascita: ${user!.birth_date.day}-${user!.birth_date.month}-${user!.birth_date.year}"),
        ListTile(title: Text("Indirizzo"),subtitle:Text(user!.address)),
          //Text("Indirizzo: ${user!.address}"),
        ListTile(title: Text("Nucleo familiare"),subtitle:Text("${user!.family}")),
          //Text("Nucleo familiare: ${user!.family}"),
        ListTile(title: Text("Tipologia abitazione"),subtitle:Text(user!.house_type)),
          //Text("Tipologia abitazione: ${user!.house_type}"),
        ListTile(title: Text("Quartiere"),subtitle:Text(user!.neighborhood)),
          //Text("Quartiere: ${user!.neighborhood}"),
        Container(
          //height: 50,
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
                advancedAlertDialog(
                    buttonMessage: "Disconnettiti",
                    title: "Conferma disconnessione",
                    message: "Sei sicuro di volerti disconnettere?",
                    f: logout,
                    context: context);
              },
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text('Disconnetti'),
              )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                advancedAlertDialog(
                    buttonMessage: "Elimina",
                    title: "Eliminazione account",
                    message:
                        "Sei sicuro di voler eliminare l'account? Questa azione è irreversibile.",
                    f: deleteAccount,
                    context: context);
              },
              child: const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text('Elimina profilo'),
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
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
