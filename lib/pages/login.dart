import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:fastenglish/main.dart';
import 'package:fastenglish/pages/RestablecerContra.dart';
import 'package:fastenglish/pages/register.dart';
import 'package:fastenglish/pages/verificarEmailPage.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class login extends StatefulWidget {
  @override
  _StateLogin createState() => _StateLogin();
}

class _StateLogin extends State<login> {
  final TextEditingController _textCorreoController = TextEditingController();
  final TextEditingController _textContraController = TextEditingController();
  static const _backgroundColor = Color.fromARGB(197, 255, 255, 255);

  static const _colors = [
    Color.fromARGB(104, 247, 6, 155),
    Color.fromARGB(97, 58, 61, 245),
  ];

  static const _durations = [
    5000,
    4000,
  ];

  static const _heightPercentages = [
    0.65,
    0.66,
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            WaveWidget(
              config: CustomConfig(
                colors: _colors,
                durations: _durations,
                heightPercentages: _heightPercentages,
              ),
              backgroundColor: _backgroundColor,
              size: const Size(double.infinity, double.infinity),
              waveAmplitude: 0,
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              margin: const EdgeInsets.only(top: 100),
              child: const Text(
                "INICIAR SESSION",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 75,
            ),
            SingleChildScrollView(
              child: Container(
                width: Size.infinite.width * 0.5,
                height: 500,
                margin: const EdgeInsets.only(left: 40, right: 40, top: 200),
                child: Form(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: _textCorreoController,
                          maxLines: 1,
                          cursorHeight: 25,
                          cursorColor: Colors.red,
                          decoration: const InputDecoration(
                            labelText: " E-mail",
                            labelStyle:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                            suffixIcon:
                                Icon(Icons.email_outlined, color: Colors.purple),
                            border: InputBorder.none,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Ingrese un E-mail valido'
                                  : null,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: _textContraController,
                          maxLines: 1,
                          cursorColor: Colors.red,
                          obscureText: true,
                          cursorHeight: 25,
                          decoration: const InputDecoration(
                            labelText: " Contrase??a",
                            labelStyle:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                            suffixIcon: Icon(Icons.lock_outline_rounded,
                                color: Colors.purple),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "??Aun no tienes una cuenta?, ",
                            style: TextStyle(color: Colors.black, fontSize: 13),
                          ),
                          TextButton(
                            //onPressed:() => Get.toNamed("/SignUp"),
                            onPressed: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const registerAuth()),
                              )
                            },
                            child: const Text(
                              "Registrate Aqui",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const RestablecerContra())),
                        child: const Text(
                          "??Olvidaste tu contrase??a?",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        //onPressed: () => Get.offAllNamed("/principalSession"),
                        onPressed: signIn,
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.purple),
                            fixedSize: MaterialStateProperty.all(
                                const Size.fromWidth(150))),
                        child: const Text("Ingresar"),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                              ),
                            ),
                            Text(' O '),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: Size.infinite.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 22, 26, 248),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton.icon(
                          icon: const Icon(
                            Icons.facebook,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: const Text('Iniciar con Facebook',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onPressed: _signFaceboock,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _textCorreoController.text.trim(),
        password: _textContraController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.message.toString(),
          style: const TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.white,
      ));
    }
  }

  Future _signFaceboock() async{
    try{  
      DatabaseReference ref = FirebaseDatabase.instance.ref("Users");
      
      final faceLogin = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(faceLogin.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      
      String UserName= userData['name'].toString();
      String email= userData['email'].toString();
      String image= userData['picture']['data']['url'].toString();
      AppState().saveUsers(UserName, email, image);
      
      

    }on FirebaseAuthException catch (e) {
      print(e.message.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.message.toString(),
          style: const TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.white,
      ));
    }
  }

}
