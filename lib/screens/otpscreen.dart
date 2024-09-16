import 'package:shop/screens/personaldetails.dart';
import 'package:shop/service/apiservice.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:uuid/uuid.dart';

class OtpVerificationPage extends StatefulWidget {
  final String number;
  final String otp;

  OtpVerificationPage({super.key, required this.number, required this.otp});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  late Timer _timer;
  int _start = 60;
  bool _isResendEnabled = false;
  ApiService apiService = ApiService();
  final Uuid uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());
    _startTimer();
    _sendOtp();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _start = 60;
    _isResendEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isResendEnabled = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _sendOtp() async {
    apiService.sendOtp(widget.number);
  }

  void _onChanged(String value, int index) {
    if (value.length == 1) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context)
            .unfocus(); // Hide the keyboard or move focus away
      }
    } else if (value.isEmpty) {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  Future<void> _handleVerify() async {
    final otpValues =
        _controllers.map((controller) => controller.text).join('');
    if (otpValues == widget.otp) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PersonalDetails(
                    userId: uuid.v4(),
                  )));
    } else {
      print(' hiiiiiiiiiiiiiii ${widget.otp}');
      print(' kkkkkkkkkkkkkkkk $otpValues  ');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  Future<void> _handleSendAgain() async {
    await _sendOtp();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.message,
                size: 100,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'We have sent a unique OTP number to your mobile ${widget.number}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) => _onChanged(value, index),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  _start > 0
                      ? '00:${_start.toString().padLeft(2, '0')}'
                      : '00:00',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _isResendEnabled ? _handleSendAgain : null,
                  child: Text(
                    'Send again',
                    style: TextStyle(
                        color: _isResendEnabled ? Colors.blue : Colors.grey,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleVerify,
        child: const Icon(Icons.arrow_right_alt_outlined),
      ),
    );
  }
}
