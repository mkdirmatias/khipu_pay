import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:khipu_pay/encrypt_data.dart';
import 'package:http/http.dart' as http;

class KhipuPayment {
  EncryptData _encryptData = new EncryptData();

  Future<String> getPaymentId({
    @required String id,
    @required String secret,
    @required String subject,
    @required String amount,
    @required String currency,
    String email,
  }) async {
    String method = "POST";
    var url = 'https://khipu.com/api/2.0/payments';

    var toSign = new StringBuffer(
        method.toUpperCase() + "&" + _encryptData.percentEncode(url));

    Map parameters = new Map<String, dynamic>();
    parameters["subject"] = subject;
    parameters["amount"] = amount;
    parameters["currency"] = currency;
    parameters["payer_email"] = email;

    var sortedKeys = parameters.keys.toList()..sort();
    for (var key in sortedKeys) {
      toSign.write('&' +
          _encryptData.percentEncode(key) +
          '=' +
          _encryptData.percentEncode(parameters[key]));
    }

    String sign = _encryptData.hmacSHA256(secret, toSign.toString());
    String authorization = '$id' + ':' + sign;

    var postData = new StringBuffer();
    for (var key in parameters.keys) {
      if (postData.length > 0) {
        postData.write('&' +
            _encryptData.percentEncode(key) +
            '=' +
            _encryptData.percentEncode(parameters[key]));
      } else {
        postData.write(_encryptData.percentEncode(key) +
            '=' +
            _encryptData.percentEncode(parameters[key]));
      }
    }

    var response = await http.post(
      url + '?' + postData.toString(),
      headers: {
        'Authorization': authorization,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map responseMap = json.decode(response.body);
      print("paymentId: " + responseMap["payment_id"]);
      return responseMap["payment_id"];
    } else {
      final Map parsed = json.decode(response.body);
      print(parsed);
      return "";
    }
  }
}
