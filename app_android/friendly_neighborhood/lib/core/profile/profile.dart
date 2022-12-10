// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
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

  Future<void> _showAlertDialog(
      {required String title,
      required String message,
      required String buttonMessage,
      required Function f}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // L'utente deve premere il pulsante
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(buttonMessage),
              onPressed: () {
                Navigator.of(context).pop();
                f();
              },
            ),
          ],
        );
      },
    );
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
                _showAlertDialog(
                    buttonMessage: "Disconnettiti",
                    title: "Conferma disconnessione",
                    message: "Sei sicuro di volerti disconnettere?",
                    f: logout);
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
                _showAlertDialog(
                    buttonMessage: "Elimina",
                    title: "Eliminazione account",
                    message:
                        "Sei sicuro di voler eliminare l'account? Questa azione è irreversibile.",
                    f: deleteAccount);
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
            return const CircularProgressIndicator();
          }
        });
  }
}
