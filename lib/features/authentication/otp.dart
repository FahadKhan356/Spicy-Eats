import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatelessWidget {
  static const String routename = '/OtpScreen';
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Column(
              children: [
                Center(
                  child: Text(
                      'Verify your number, and we’ll take care of the rest!',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text('Enter your OTP code here',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        // shadows: [
                        //   const BoxShadow(
                        //     color: Colors.black,
                        //     offset: Offset(2, 1),
                        //     blurRadius: 1,
                        //     spreadRadius: 2,
                        //   ),
                        // ]
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                OtpTextField(
                  numberOfFields: 5,
                  borderWidth: 4,
                  enabledBorderColor: Colors.black,
                  borderColor: Color(0xFF512DA8),
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Verification Code"),
                            content: Text('Code entered is $verificationCode'),
                          );
                        });
                  }, // end onSubmit
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Image.asset(
                    'lib/assets/images/pizza.png',
                    height: 300,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
