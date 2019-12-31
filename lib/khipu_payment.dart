import 'dart:convert';

import 'package:diacritic/diacritic.dart';
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
    validateFields(id, secret, subject, amount, currency, email);

    String method = "POST";
    var url = 'https://khipu.com/api/2.0/payments';

    var toSign = new StringBuffer(
        method.toUpperCase() + "&" + _encryptData.percentEncode(url));

    Map parameters = new Map<String, dynamic>();
    parameters["subject"] = removeDiacritics(subject);
    parameters["amount"] = amount;
    parameters["currency"] = currency;
    if (email != null && email.isNotEmpty) parameters["payer_email"] = email;

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
      final Map responseMap = json.decode(response.body);
      print(responseMap);
      return responseMap["message"];
    }
  }

  void validateFields(
    String id,
    String secret,
    String subject,
    String amount,
    String currency,
    String email,
  ) {
    if (id != null && id.isEmpty) {
      throw ArgumentError.value(id, 'id cannot be empty or null');
    }

    if (secret != null && secret.isEmpty) {
      throw ArgumentError.value(secret, 'secret cannot be empty or null');
    }

    if (subject != null && subject.isEmpty) {
      throw ArgumentError.value(subject, 'subject cannot be empty or null');
    }

    var amountInt = int.parse(amount);
    if (amount != null && amount.isEmpty) {
      throw ArgumentError.value(amount, 'amount cannot be empty or null');
    } else if (amountInt is int && amountInt <= 0) {
      throw ArgumentError.value(
          amount, 'amount must be an int and greater than 0');
    }

    if (currency != null && currency.isEmpty) {
      throw ArgumentError.value(currency, 'currency cannot be empty or null');
    }

    if (email != null && email.isNotEmpty && !validateEmail(email)) {
      throw ArgumentError.value(email, 'wrong email format');
    }
  }

  bool validateEmail(String email) {
    if (RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }
}
