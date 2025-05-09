import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swachh_alert/screens/cameraLocation_screen.dart';
import 'package:swachh_alert/screens/sharedpreference.dart';
import 'package:swachh_alert/services/apiServices.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String phoneNumber;
  const VerifyCodeScreen({Key? key, required this.phoneNumber})
    : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  late Timer _timer;
  int _remainingTime = 30;
  APIService _apiService = APIService();
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void onLoginSuccess(String phoneNumber) {
    fetchAndStoreUserData(phoneNumber);
  }

  void verifyOtp() async {
    String phoneNumber = widget.phoneNumber;

    // Combine the OTP from all four controllers
    String otp = otpControllers.map((controller) => controller.text).join();

    if (otp.length == 4) {
      // Ensure all digits are entered
      bool isVerified = await _apiService.verifyOtp(
        phoneNumber,
        otp,
      ); // Call API service

      if (!mounted) return;
      if (isVerified) {
        CustomSnackBar.show(
          context,
          isVerified
              ? "OTP Varification successful!"
              : "Failed to varification. Try again.",
        );
        onLoginSuccess(phoneNumber);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => BasicInformationScreen(
        //             phoneNumber: phoneNumber,
        //           )), // Replace with your next screen
        // );
      }
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.03),
              // Center(
              //   child: Image.asset(AppAssets.verifyimg,
              //       width: screenWidth * 0.7, height: screenHeight * 0.35),
              // ),
              SizedBox(height: screenHeight * 0.014),
              Text(
                'Verify Code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              /// **OTP Fields**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => otpBox(
                    context,
                    otpControllers[index],
                    focusNodes[index],
                    index < 3 ? focusNodes[index + 1] : null,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'resend code in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                        TextSpan(
                          text:
                              '  00:${_remainingTime.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_remainingTime == 0) {
                        setState(() {
                          _remainingTime = 30;
                          _startCountdown();
                        });
                      }
                    },
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             BottomnavigationbarScreen()));
                      },
                      child: Text(
                        "didn't receive code?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.036,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.07),

              /// **Verify Button**
              SizedBox(
                height: screenHeight * 0.06,
                width: screenWidth * 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    verifyOtp();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraLocationAIPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    'Verify OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // child: OnboardingButton(
                //     onPressed: () {
                //       verifyOtp();
                //     },
                //     buttonText: AppString.verifyOtp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget otpBox(
    BuildContext context,
    TextEditingController controller,
    FocusNode currentNode,
    FocusNode? nextNode,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenWidth * 0.15,
      width: screenWidth * 0.15,
      child: TextField(
        cursorColor: Colors.white,
        controller: controller,
        focusNode: currentNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(fontSize: screenWidth * 0.06, color: Colors.white),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(2),
          ),
          fillColor: Colors.black,
          filled: true,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextNode != null) {
            FocusScope.of(context).requestFocus(nextNode);
          }
        },
      ),
    );
  }
}

class CustomSnackBar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
