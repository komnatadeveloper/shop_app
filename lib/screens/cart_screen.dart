import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/cart_provider.dart' show Cart;
import '../providers/orders_provider.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {

  static  const routeName = '/cart';

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.headline6.color
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text(
                      'ORDER NOW'
                    ),
                    onPressed: () {
                      Provider.of<OrdersProvider>(
                          context,
                          listen: false
                        )
                        .addOrder(
                          cartProvider.items.values.toList(),
                          cartProvider.totalAmount,                           
                        );

                      cartProvider.clearCart();
                    },
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child : ListView.builder(
              itemBuilder: (ctx, index) {
                return CartItem(
                  cartProvider.items.values.toList()[index].id,
                  cartProvider.items.keys.toList()[index],
                  cartProvider.items.values.toList()[index].price,
                  cartProvider.items.values.toList()[index].quantity,
                  cartProvider.items.values.toList()[index].title,

                );

              },
              itemCount: cartProvider.itemCount,
            )
          )
        ],
      ),
    );
  }
}