// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/profile/modify_profile.dart';
import 'package:friendly_neighborhood/first_page/login_screen.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/utils/alertdialog.dart';

import '../dashboard/dashboard.dart';

/*
* Classe Profile:
* La seguente classe si occupa di generare l'interfaccia con le informazioni
* del profilo dell'utente corrente
*/
class Profile extends StatefulWidget {
  final CoreCallback switchBody;
  const Profile({super.key, required this.switchBody});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late LocalUser? user;
  final LocalUserManager luManager = LocalUserManager();

/*
* funzione logout
* la seguente funzione si occupa eseguire il logout e di cambiare la pagina
* tornando a quella di login
*/
  void logout() async {
    await luManager.deleteUser(user!);
    await API_Manager.logout(user!.email);
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

/*
* funzione deleteAccount
* la seguente funzione di eliminare l'account corrente e di cambiare la pagina
* tornando a quella di login
*/
  void deleteAccount() async {
    await luManager.deleteUser(user!);
    await API_Manager.deleteAccount(user!.token);
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

/*
* funzione _asyncBuilder
* la seguente genera la pagina una volta completate le operazioni di caricamento dei dati
*/
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
      children: [
        ListTile(title: const Text("Username"), subtitle: Text(user!.username)),
        ListTile(title: const Text("E-mail"), subtitle: Text(user!.email)),
        ListTile(title: const Text("Nome"), subtitle: Text(user!.name)),
        ListTile(title: const Text("Cognome"), subtitle: Text(user!.lastname)),
        ListTile(
            title: const Text("Data di nascita"),
            subtitle: Text(
                "${user!.birth_date.day}-${user!.birth_date.month}-${user!.birth_date.year}")),
        ListTile(title: const Text("Indirizzo"), subtitle: Text(user!.address)),
        ListTile(
            title: const Text("Nucleo familiare"),
            subtitle: Text("${user!.family}")),
        ListTile(
            title: const Text("Tipologia abitazione"),
            subtitle: Text(user!.house_type)),
        ListTile(
            title: const Text("Quartiere"), subtitle: Text(user!.neighborhood)),
        Container(
            //height: 50,
            ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.home),
              onPressed: () {
                widget.switchBody("Dashboard");
              },
              label: const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text('Vai alla dashboard'),
              )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModifyProfile(user: user!)))
                    .then((value) => setState(() {}));
              },
              label: const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text('Modifica profilo'),
              )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () {
                advancedAlertDialog(
                    buttonMessage: "Disconnettiti",
                    title: "Conferma disconnessione",
                    message: "Sei sicuro di volerti disconnettere?",
                    f: logout,
                    context: context);
              },
              label: const Center(
                  child: Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text('Disconnetti'),
              )),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever),
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
              label: const Center(
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
