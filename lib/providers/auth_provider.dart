

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../local_environment/vars.dart';

class AuthProvider with ChangeNotifier {

  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup (String email, String password) async {



    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';

    final res = await http.post(
      url,
      body: json.encode({
        'email': email.trim(),
        'password': password,
        'returnSecureToken': true
      })
    );

    print( json.decode( res.body )['email'] );


  }
}