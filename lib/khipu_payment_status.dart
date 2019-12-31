import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khipu_pay/encrypt_data.dart';

class KhipuPaymentStatus {
  EncryptData _encryptData = new EncryptData();

  Future<String> status({
    @required String transactionCode,
    @required String id,
    @required String secret,
  }) async {
    String method = "GET";
    String url = "https://khipu.com/api/2.0/payments/" + transactionCode;

    var toSign = new StringBuffer(
        method.toUpperCase() + "&" + _encryptData.percentEncode(url));

    String sign = _encryptData.hmacSHA256(secret, toSign.toString());
    String authorization = '$id' + ':' + sign;

    var response = await http.get(
      url,
      headers: {
        'Authorization': authorization,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map responseMap = json.decode(response.body);
      print("responseMap.status: " + responseMap['status']);
      return responseMap['status'];
    } else {
      print("response.body: " + response.body);
      return '';
    }
  }
}
