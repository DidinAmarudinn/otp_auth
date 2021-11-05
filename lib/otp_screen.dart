import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification/home.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  const OtpScreen(
      {Key? key, required this.phoneNumber, required this.countryCode})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  dynamic onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String? verificationCode;
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    verfyNumber();
    super.initState();
  }

  verfyNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.countryCode + widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if (value.user != null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => const Home()));
            }
          });
        },
        verificationFailed: (FirebaseAuthException exception){
          ScaffoldMessenger.of(context)
                            .showSnackBar( SnackBar(
                          content: Text(exception.message??""),
                          duration:const Duration(seconds: 2),
                        ));
                        // ignore: avoid_print
                        print(exception.message);
        },
        codeSent: (String? vid,int? resentToke){
          setState(() {
            verificationCode =vid;
          });
        },
        codeAutoRetrievalTimeout: (String? vid){
          setState(() {
            verificationCode = vid;
          });
        },
        timeout:const Duration(seconds: 30));
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.45,
            width: width,
            child: Stack(children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: width * 0.5,
                  width: width * 0.5,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Image.asset(
                "assets/ilustration2.png",
                width: width,
              ),
              Positioned(
                  top: 50,
                  left: 24,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[400]!,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.navigate_before,
                          size: 30,
                        ),
                      ),
                    ),
                  ))
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "OTP Verification",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "Enter the OTP sent to +62${widget.phoneNumber}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 48),
                Form(
                  key: formKey,
                  child: PinCodeTextField(
                    appContext: context,
                    keyboardType: TextInputType.number,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: width * 0.14,
                      inactiveFillColor: Colors.white,
                      fieldWidth: width * 0.13,
                      inactiveColor: Colors.grey,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      activeColor: Colors.blue,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    onCompleted: (v) async {
                      try {
                        await FirebaseAuth.instance
                            .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: verificationCode!, smsCode: v))
                            .then((value) {
                          if (value.user != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const Home()));
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Invalid OTP"),
                          duration: Duration(seconds: 2),
                        ));
                        throw Exception(e);
                      }
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    beforeTextPaste: (text) {
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    formKey.currentState!.validate();
                    // conditions for validating
                    if (currentText.length != 6 || currentText != "towtow") {
                      errorController.add(ErrorAnimationType
                          .shake); // Triggering error shake animation
                      setState(() {
                        hasError = true;
                      });
                    } else {
                      setState(() {
                        hasError = false;
                      });
                    }
                  },
                  child: Container(
                    height: 60,
                    width: width,
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blue.withOpacity(0.25),
                            offset: const Offset(0, 16),
                            blurRadius: 20)
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Send OTP",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Don't recive the OTP? "),
                    Text(
                      "Resend",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
