import 'package:flutter/material.dart';

// HTTP and convert
import 'package:http/http.dart' as http;
import 'dart:convert';


import './product.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {

  List<Product> _items ;

  final String authToken;
  ProductsProvider( this.authToken, this._items );


  List<Product> get items {


    return [..._items];
  }

  Product findById ( String id) {
    return _items
      .firstWhere(
      (element) => element.id == id
    );
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts () async {

    final url = 'https://komnata-shop-app.firebaseio.com/products.json?auth=$authToken';

    try {

      final res = await http.get(url);
      final extractedData = json
        .decode( res.body )
        as Map<String, dynamic>;

      if( extractedData == null ) {
        return;
      }

      final List<Product> loadedProducts = [];
      extractedData.forEach( ( prodId, prodData ) {
        loadedProducts.add(  
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: prodData['isFavorite'],
            imageUrl: prodData['imageUrl'],
          )
        );
      });

      _items =loadedProducts;
      notifyListeners();
        

    } catch ( err ) {

      throw( err );
    }
  }


  Future<void> addProduct( Product product ) async {

    const url = 'https://komnata-shop-app.firebaseio.com/products.json';
    try {

      final response = await  http.post(
        url, 
        body: json.encode( {
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        } )
      );

    final newProduct = Product(
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      id: json.decode(response.body)['name']
    );

    _items.add(newProduct);
    notifyListeners();

    }  catch (err) {
      print(err);
      throw err;
    }

  }

  Future<void> updateProduct ( String id, Product newValues ) async {


    final prodIndex = _items.indexWhere(
      (element) => element.id == id
    );

    if( prodIndex >= 0 ) {

      final url = 'https://komnata-shop-app.firebaseio.com/products/$id.json';

      final res =await http.patch(
        url,
        body: json.encode({
        'title': newValues.title,
        'description': newValues.description,
        'imageUrl': newValues.imageUrl,
        'price': newValues.price,
        // 'isFavorite': newValues.isFavorite,
        })
      );

      print( json.decode(res.body) );

      _items[prodIndex] = newValues;

      notifyListeners();
    } else {

    }
  } 

  Future<void> deleteProduct ( String id ) async {
    final url = 'https://komnata-shop-app.firebaseio.com/products/$id.json';

    final existingProductIndex = _items.indexWhere(
      (element) => element.id == id
    );
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final res = await http.delete(
      url,      
    );

    if( res.statusCode >= 400 ) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpMyException(
        'Could not delete product'
      );
    } 

    existingProduct = null;



    // _items.removeWhere(
    //   (element) => element.id == id 
    // );
    // notifyListeners();
  }  // end of deleteProduct

}