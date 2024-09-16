import 'dart:math';

import 'package:shop/screens/otpscreen.dart';
import 'package:shop/service/apiservice.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPhoneSelected = true;
  final TextEditingController _controller = TextEditingController();

  ApiService apiService = ApiService();

  final Random random = Random();
  int otp = 0;
  late String _sentOtp;

  String generateOtp() {
    _sentOtp = otp.toString().padLeft(4, '0');
    print(_sentOtp);
    print(otp.toString().padLeft(4, '0'));
    return random.nextInt(10000).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Glad to see you!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                  'Please provide your ${isPhoneSelected ? 'phone number' : 'email'}'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: isPhoneSelected ? 'Phone' : 'Email',
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 40,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter phone number')),
                      );
                    } else {
                      if (_controller.text.length < 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Enter the correct phone number')),
                        );
                      } else {
                        apiService.sendOtp(_controller.text);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpVerificationPage(
                                      number: _controller.text.toString(),
                                      otp: generateOtp(),
                                    )));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'SEND CODE',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
