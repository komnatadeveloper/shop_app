

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../local_environment/vars.dart';
import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {

  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if( 
      _expiryDate != null 
      && _expiryDate.isAfter( DateTime.now() )
      && _token != null  ) {

      return _token;
    }

    return null;
  }


  Future<void> signup (String email, String password) async {

    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';

    try {

      final res = await http.post(
        url,
        body: json.encode({
          'email': email.trim(),
          'password': password,
          'returnSecureToken': true
        })
      );

      final responseData = json.decode( res.body );
      if( responseData['error'] != null ) {
        throw HttpMyException( responseData['error']['message'] );
      }

      // No error Case
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds:  int.parse( responseData['expiresIn'] )
        )
      );
      notifyListeners();

      print( json.decode( res.body )['email'] );
    } catch ( err ) {
      throw err;

    }


  }  // end of sign up


  Future<void> signin ( String email, String password ) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';

    try { 

      final res = await http.post(
        url,
        body: json.encode({
          'email': email.trim(),
          'password': password,
          'returnSecureToken': true
        })
      );

      final responseData = json.decode( res.body );
      if( responseData['error'] != null ) {
        throw HttpMyException( responseData['error']['message'] );
      }

      // No error Case
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds:  int.parse( responseData['expiresIn'] )
        )
      );
      notifyListeners();

    } catch  ( err ) {

      throw err;
    }


  }  // end of sign in



}