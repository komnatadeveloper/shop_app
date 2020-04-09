import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../providers/orders_provider.dart' as ord;

class OrderItem extends StatefulWidget {

  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}


// STATE
class _OrderItemState extends State<OrderItem> with SingleTickerProviderStateMixin {

  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _expanded 
      ? min(
        widget.order.products.length * 25.0 + 110,
        200
      ) 
      : 95,
      duration: Duration(milliseconds: 300),
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                '\$${widget.order.amount.toStringAsFixed(2)}'
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)
              ),
              trailing: IconButton(
                icon: Icon( _expanded 
                  ? Icons.expand_less
                  : Icons.expand_more
                ),
                onPressed: () {
                  setState(() {
                    // if( !_expanded  ) {
                    //   _controller.forward();
                    // } else {
                    //   _controller.reverse();
                    // }
                    _expanded = !_expanded;
                  });
                },
              ),
            ),

            // if Expanded
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4
              ),
              height: _expanded
              ? min(
                widget.order.products.length * 25.0 + 10,
                130
              )
              : 0,
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: ( _ , index ) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.order.products[index].title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      '${widget.order.products[index].quantity}x \$${widget.order.products[index].price}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey
                      ),
                    )
                  ],
                )
              ),
            ),            
          ],
        ),
      ),
    );
  }
}