import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:swachh_alert/screens/otp_screen.dart';
import 'package:swachh_alert/services/apiServices.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final APIService _apiService = APIService();

  Future<void> _sendOtp() async {
    String phoneNumber = _phoneController.text.trim();

    if (!mounted) return;
    if (phoneNumber.isNotEmpty) {
      _apiService.generateOtp(phoneNumber);
      print('opt send successfully!');
    } else {
      print("Please enter a valid phone number");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final double screenHeight = constraints.maxHeight;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    // Center(
                    //   child: Image.asset(
                    //     registrationimg,
                    //     width: screenWidth * 0.6,
                    //   ),
                    // ),
                    SizedBox(height: screenHeight * 0.055),
                    FittedBox(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: _formKey,

                      child: IntlPhoneField(
                        onChanged: (value) {
                          // Manually call validation when text changes
                          _formKey.currentState?.validate();
                        },
                        validator: (value) {
                          if (value == null || value.number.isEmpty) {
                            return "Please enter a phone number";
                          } else if (!RegExp(
                            r'^[6-9]\d{9}$',
                          ).hasMatch(value.number)) {
                            return "Enter a valid 10-digit phone number";
                          }
                          return null; // No error
                        },
                        controller: _phoneController,
                        initialCountryCode: 'IN',
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: 'mobileNo',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.035,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.phone,
                        dropdownTextStyle: TextStyle(color: Colors.white),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'make sure you select a country code before entering your number',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.040,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    SizedBox(height: screenHeight * 0.07),
                    ElevatedButton(
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder:
                        //           (context) => VerifyCodeScreen(
                        //             phoneNumber: _phoneController.text.trim(),
                        //           ),
                        //     ),
                        //   );
                        _sendOtp();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => VerifyCodeScreen(
                                  phoneNumber: _phoneController.text.trim(),
                                ),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.2,
                          vertical: screenHeight * 0.02,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        'send otp',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: screenHeight * 0.065,
                    //   width: screenWidth * 0.4,
                    //   // child: OnboardingButton(
                    //   //     onPressed: () {
                    //   //       if (_formKey.currentState!.validate()) {
                    //   //         _sendOtp();
                    //   //         // Navigator.push(
                    //   //         //   context,
                    //   //         //   MaterialPageRoute(
                    //   //         //     builder: (context) => OtpScreen(
                    //   //         //       phoneNumber: _phoneController.text.trim(),
                    //   //         //     ),
                    //   //         //   ),
                    //   //         // );
                    //   //       }
                    //   //     },
                    //   //     buttonText: 'send otp')
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
