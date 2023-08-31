import 'package:flutter/material.dart';

class AuthOverviewScreen extends StatefulWidget {
  const AuthOverviewScreen({super.key});

  @override
  State<AuthOverviewScreen> createState() => _AuthOverviewScreenState();
}

class _AuthOverviewScreenState extends State<AuthOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 600,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 30,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Se connecter",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Veuillez entrer vos identifiants,",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez remplir ce champ';
                    }
                    return null;
                  },
                  // focusNode: focusMail,
                  textInputAction: TextInputAction.next,
                  // onFieldSubmitted: (v) {
                  //   FocusScope.of(context).requestFocus(focusClasse);
                  // },
                  // controller: mailController,
                  decoration: const InputDecoration(
                    labelText: "Adresse mail",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.mail_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez remplir ce champ';
                    }
                    return null;
                  },
                  // focusNode: focusMail,
                  textInputAction: TextInputAction.next,
                  // onFieldSubmitted: (v) {
                  //   FocusScope.of(context).requestFocus(focusClasse);
                  // },
                  // controller: mailController,
                  decoration: const InputDecoration(
                    labelText: "Mot de passe",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  child: Text("Se connecter"),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
