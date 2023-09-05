import 'package:flutter/material.dart';

class NumberConfirmationAuthWidget extends StatefulWidget {
  const NumberConfirmationAuthWidget(
      {required this.numberController,
      required this.otpController,
      required this.otpFieldVisibility,
      super.key});
  final TextEditingController numberController;
  final TextEditingController otpController;
  final bool otpFieldVisibility;

  @override
  State<NumberConfirmationAuthWidget> createState() =>
      _NumberConfirmationAuthWidgetState();
}

class _NumberConfirmationAuthWidgetState
    extends State<NumberConfirmationAuthWidget> {
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
            controller: widget.numberController,
            decoration: const InputDecoration(
              labelText: "Numéro de téléphone",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers_outlined),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        widget.otpFieldVisibility
            ? Padding(
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
                  controller: widget.otpController,
                  decoration: const InputDecoration(
                    labelText: "Code de confirmation",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
              )
            : const Text(""),
      ],
    );
  }
}
