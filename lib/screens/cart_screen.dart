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
                        // color: Theme.of(context).primaryTextTheme.headline6.color   2020.03.12 ERROR to be solved afet format
                        color: Theme.of(context).primaryTextTheme.title.color
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartProvider: cartProvider)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartProvider,
  }) : super(key: key);

  final Cart cartProvider;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
        ? 
        CircularProgressIndicator()
        :
        Text(
          'ORDER NOW'
        ),
      onPressed:  (widget.cartProvider.totalAmount <= 0  || _isLoading )
        ? 
        null
        :
        () async {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<OrdersProvider>(
              context,
              listen: false
            )
            .addOrder(
              widget.cartProvider.items.values.toList(),
              widget.cartProvider.totalAmount,                           
          );

          setState(() {
            _isLoading = false;
          });

          widget.cartProvider.clearCart();
        },
      textColor: Theme.of(context).primaryColor,
    );
  }
}