import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../model/bannermodel.dart';

class ApiService {
  final String baseUrl = "http://devapiv4.dealsdray.com/api/v2/user";
  final Uuid uuid = const Uuid();
  List categories = [];

  Future<void> sendOtp(String mobileNumber) async {
    final url = "$baseUrl/otp";
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"mobileNumber": mobileNumber, "deviceId": uuid.v4()}),
    );

    if (response.statusCode == 200) {
      print("OTP sent successfully");
    } else {
      print("Failed to send OTP: ${response.statusCode}");
    }
  }

  Future<void> verifyOtp(String otp) async {
    final String url = "$baseUrl/otp/verification";
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "otp": otp,
        "deviceId": "device${uuid.v4()}",
        "userId": "user${uuid.v4()}",
      }),
    );

    if (response.statusCode == 200) {
      print('OTP Verified: ${response.body}');
    } else {
      print('OTP Verification Error: ${response.statusCode}');
    }
  }

  Future<BannerData> fetchBannerData() async {
    final response = await http.get(Uri.parse(
        'http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'));

    if (response.statusCode == 200) {
      // Print the full response for debugging
      print("Response Body: ${response.body}");

      // Check if 'data' is present and contains required fields
      final Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData.containsKey('data')) {
        return BannerData.fromJson(jsonData['data']);
      } else {
        throw Exception("Data not found in response");
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
