import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product( {
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false
  } );

  Future<void> toggleFavoriteStatus () async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();


    final url = 'https://komnata-shop-app.firebaseio.com/products/$id.json';

    try {

      final res =await http.patch(
        url,
        body: json.encode({
        'isFavorite': isFavorite,
        })
      );

      if( res.statusCode >= 400 ) {
        isFavorite = oldStatus;
        notifyListeners();
      }
      print( json.decode( res.body ) );
      print( 'Status code' +  res.statusCode.toString() );

    } catch ( err ) {
      isFavorite = oldStatus;
      notifyListeners();
      throw err;

    }


  } 
}