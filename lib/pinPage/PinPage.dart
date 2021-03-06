import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pin_app/contactsPage/ContactsPage.dart';
import 'package:better_sound_effect/better_sound_effect.dart';
import 'package:flutter/cupertino.dart';

class PinPage extends StatefulWidget {
  const PinPage({Key? key}) : super(key: key);

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  Random rand = new Random();
  String randomNumber = "";
  final soundEffect = BetterSoundEffect();
  int? successId;
  int? failId;
  String currentText = '';
  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    randomNumber = (rand.nextInt(9999 - 1000) + 1000).toString();
    super.initState();
    Future.microtask(() async {
      successId =
          await soundEffect.loadAssetAudioFile("assets/sounds/success.wav");
    });
    Future.microtask(() async {
      failId = await soundEffect.loadAssetAudioFile("assets/sounds/fail.wav");
    });
  }

  @override
  void dispose() {
    if (errorController != null) {
      errorController!.close();
    }

    if (successId != null) {
      soundEffect.release(successId!);
    }
    if (failId != null) {
      soundEffect.release(failId!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue[600]!,
                Colors.purple[500]!,
              ], begin: Alignment.topLeft),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: PinCodeTextField(
                  appContext: context,
                  keyboardType: TextInputType.number,
                  length: 4,
                  obscuringWidget: Image.asset(
                    'assets/images/asterisk.png',
                    width: 20,
                  ),
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 're-enter pin code';
                    }
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.black,
                    inactiveColor: Colors.white,
                    fieldHeight: 50,
                    fieldWidth: 40,
                  ),
                  animationDuration: Duration(milliseconds: 500),
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.white,
                      blurRadius: 50,
                    )
                  ],
                  onCompleted: (currentText) {
                    if (currentText == randomNumber) {
                      if (successId != null) {
                        soundEffect.play(successId!);
                      }
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactsPage(),
                          ),
                          ModalRoute.withName("/PinPage "));
                    } else {
                      if (failId != null) {
                        soundEffect.play(failId!);
                      }
                      textEditingController.clear();
                    }
                  },
                  onChanged: (value) {
                    setState(
                      () {
                        currentText = value;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 25, 25),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.black,
                      context: context,
                      builder: (context) {
                        return AnimatedContainer(
                          duration: Duration(seconds: 3),
                          height: 100,
                          padding: EdgeInsets.only(top: 25),
                          child: Text(
                            randomNumber.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        );
                      });
                },
                child: Text("Pin Code"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
