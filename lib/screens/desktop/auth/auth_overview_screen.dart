import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lockers_app/screens/desktop/auth/widgets/sign_in/mail_password_auth_widget.dart';
import 'package:lockers_app/screens/desktop/auth/widgets/sign_in/number_confirmation_auth_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthOverviewScreen extends StatefulWidget {
  const AuthOverviewScreen({required this.onSignedIn, super.key});
  final Function onSignedIn;

  @override
  State<AuthOverviewScreen> createState() => _AuthOverviewScreenState();
}

class _AuthOverviewScreenState extends State<AuthOverviewScreen> {
  var auth = FirebaseAuth.instance;

  bool isStayConnectedChecked = false;
  bool connectWithSMS = false;
  bool otpFieldVisibility = false;

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  var receivedID = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 600,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          // color: Colors.white,
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
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Se connecter",
                  style: TextStyle(
                    fontSize: 24,
                    // color: Theme.of(context).textSelectionTheme.selectionColor,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Veuillez entrer vos identifiants,",
                  style: TextStyle(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor),
                ),
              ),
              const SizedBox(height: 20),
              connectWithSMS
                  ? NumberConfirmationAuthWidget(
                      numberController: numberController,
                      otpController: otpController,
                      otpFieldVisibility: otpFieldVisibility,
                    )
                  : MailPasswordAuthWidget(
                      mailController: mailController,
                      passwordController: passwordController,
                    ),
              (otpFieldVisibility && connectWithSMS) || !connectWithSMS
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: Transform.translate(
                              offset: const Offset(-20, 0),
                              child: const Text(
                                "Rester connecté",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            value: isStayConnectedChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isStayConnectedChecked = value!;
                              });
                            },
                            contentPadding: const EdgeInsets.all(4),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        connectWithSMS
                            ? const Text("")
                            : TextButton(
                                child: const Text("Mot de passe oublié"),
                                onPressed: () {},
                              ),
                      ],
                    )
                  : const Text(""),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: Text(
                    otpFieldVisibility && connectWithSMS
                        ? "Confirmer"
                        : "Se connecter",
                    style: TextStyle(
                        // color: Theme.of(context)
                        //     .textSelectionTheme
                        //     .selectionColor
                        ),
                  ),
                  onPressed: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    if (connectWithSMS) {
                      if (otpFieldVisibility) {
                        try {
                          await auth.signInWithCredential(
                            PhoneAuthProvider.credential(
                              verificationId: receivedID,
                              smsCode: otpController.text,
                            ),
                          );

                          widget.onSignedIn();

                          prefs.setString(
                            "token",
                            isStayConnectedChecked == true
                                ? auth.currentUser!.getIdToken().toString()
                                : "",
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Connexion réussie !")),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      } else {
                        auth.verifyPhoneNumber(
                          phoneNumber: numberController.text,
                          verificationCompleted: (_) {},
                          verificationFailed: (FirebaseAuthException e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.message.toString())),
                            );

                            setState(() {
                              otpFieldVisibility = false;
                            });
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            receivedID = verificationId;
                            setState(() {
                              otpFieldVisibility = true;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Code de confirmation envoyé !")),
                            );
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Timeout !")),
                            );
                          },
                        );
                      }
                    } else {
                      try {
                        await auth.signInWithEmailAndPassword(
                          email: mailController.text,
                          password: passwordController.text,
                        );

                        widget.onSignedIn();

                        prefs.setString(
                          "token",
                          isStayConnectedChecked == true
                              ? auth.currentUser!.getIdToken().toString()
                              : "",
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Connexion réussie !")),
                        );
                      } on FirebaseAuthException {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Adresse mail ou mot de passe incorrecte !")),
                        );
                      }
                    }

                    // final SharedPreferences prefs =
                    //     await SharedPreferences.getInstance();

                    // try {
                    //   if (connectWithSMS) {
                    //     await auth.verifyPhoneNumber(
                    //       timeout: const Duration(seconds: 60),
                    //       phoneNumber: numberController.text,
                    //       verificationCompleted: (phoneAuthCredential) {
                    //         widget.onSignedIn();

                    //         prefs.setString(
                    //           "token",
                    //           isStayConnectedChecked == true
                    //               ? auth.currentUser!.getIdToken().toString()
                    //               : "",
                    //         );

                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(
                    //             content: Text("Connexion réussie !"),
                    //           ),
                    //         );
                    //       },
                    //       verificationFailed: (error) {
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           SnackBar(
                    //             content: Text(error.toString()),
                    //           ),
                    //         );
                    //       },
                    //       codeSent:
                    //           (verificationId, forceResendingToken) async {},
                    //       codeAutoRetrievalTimeout: (verificationId) {},
                    //     );
                    //   } else {
                    //     await auth.signInWithEmailAndPassword(
                    //         email: mailController.text,
                    //         password: passwordController.text);

                    //     widget.onSignedIn();

                    //     prefs.setString(
                    //       "token",
                    //       isStayConnectedChecked == true
                    //           ? auth.currentUser!.getIdToken().toString()
                    //           : "",
                    //     );

                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text("Connexion réussie !"),
                    //       ),
                    //     );
                    //   }
                    // } catch (e) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content:
                    //           Text("Identifiant ou mot de passe incorrecte"),
                    //     ),
                    //   );
                    // }
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    connectWithSMS = !connectWithSMS;
                  });
                },
                child: connectWithSMS
                    ? const Text("Se connecter avec mot de passe")
                    : const Text("Se connecter via SMS"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
