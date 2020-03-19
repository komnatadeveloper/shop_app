

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fot http requests http.dart & convert for json.decode & json.encode
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async';

import '../local_environment/vars.dart';
import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

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

  String get userId {
    return _userId;
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

      _autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode( {
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      } );
      prefs.setString('userData', userData);

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

      _autoLogout();

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode( {
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String()
      } );
      prefs.setString('userData', userData);

    } catch  ( err ) {

      throw err;
    }


  }  // end of sign in

  Future<bool> tryAutoLogin () async {
    final prefs = await SharedPreferences.getInstance();

    if( !prefs.containsKey( 'userData' ) ) {
      return false;
    }

    final extractedUserData = json.decode(
       prefs.getString( 'userData') 
    ) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();

    _autoLogout();

    return true;


  }  // end of tryAutoLogin


  Future<void> logout () async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if( _authTimer != null ) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    prefs.remove( 'userData' );
    // prefs.clear();   ( Would have cleared all data for all apps )  
  }

  void _autoLogout() {
    if( _authTimer != null ) {
      _authTimer.cancel();

    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer( Duration( 
        seconds: timeToExpiry
      ),
      logout
    );
  }



}