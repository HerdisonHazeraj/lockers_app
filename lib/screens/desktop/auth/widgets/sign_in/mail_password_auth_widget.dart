import 'package:flutter/material.dart';

class MailPasswordAuthWidget extends StatefulWidget {
  const MailPasswordAuthWidget(
      {required this.mailController,
      required this.passwordController,
      super.key});

  final TextEditingController mailController;
  final TextEditingController passwordController;

  @override
  State<MailPasswordAuthWidget> createState() => _MailPasswordAuthWidgetState();
}

class _MailPasswordAuthWidgetState extends State<MailPasswordAuthWidget> {
  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
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
            controller: widget.mailController,
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
            controller: widget.passwordController,
            decoration: const InputDecoration(
              labelText: "Mot de passe",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outlined),
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
          ),
        ),
      ],
    );
  }
}
