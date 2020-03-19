
import 'package:flutter/foundation.dart';

// HTTP and convert
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart_provider.dart';

class OrderItem {

  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem( {
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime
  });
}

class OrdersProvider with ChangeNotifier {

  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  OrdersProvider( this.authToken, this.userId, this._orders );

  List<OrderItem> get orders {
    return [ ..._orders ];
  } 

  Future<void> fetchAndSetOrders () async {

    final url = 'https://komnata-shop-app.firebaseio.com/orders/$userId.json?auth=$authToken';

    final res = await http.get(url);


    final List<OrderItem> loadedOrders  = [];
    final extractedData = json.decode(res.body) as Map<String, dynamic>;

    if(extractedData == null  ) {
      return;
    }

    extractedData.forEach( ( orderId, orderData )   {

      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse( orderData['dateTime'] ),
          products: (orderData['products'] as List<dynamic> ).map( 
            (prodItem) => CartItem(
              id: prodItem['id'],
              price: prodItem['price'],
              quantity: prodItem['quantity'],
              title: prodItem['title'],

            )

          ).toList()
        )
      );

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    });

  }

  Future<void> addOrder(     
      List<CartItem> cartProducts,
      double total
    ) async {

    final url = 'https://komnata-shop-app.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();

    final res = await http.post(
      url,
      body: json.encode( {
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts.map(
          (cartItem) => {
            'id': cartItem.id,
            'title': cartItem.title,
            'quantity': cartItem.quantity,
            'price': cartItem.price,
          }
        ).toList()

      })
    );

    print( json.decode(res.body) );
    
    _orders.insert(
      0, 
      OrderItem(
        id: json.decode( res.body )['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts
      )
    );

    notifyListeners();

  } // end of addOrder

}