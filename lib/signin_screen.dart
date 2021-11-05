import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification/otp_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
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
                alignment: Alignment.center,
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
                "assets/ilustration1.png",
                width: width,
              )
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
                const Text(
                  "We will send you one time password on this\nphone number",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                        prefixText: "+62"),
                        keyboardType: TextInputType.number,
                    controller: _controller,
                   
                    
                  ),
                ),
                GestureDetector(
                  onTap: () {
                  if(_controller.text.isNotEmpty){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => OtpScreen(
                                  countryCode: "+62",
                                  phoneNumber: _controller.text,
                                )));
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please input your phone number")));
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
                    Text("Don't hava an account? "),
                    Text(
                      "Sign Up",
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
