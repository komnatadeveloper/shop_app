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

class _OrderItemState extends State<OrderItem> {

  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  _expanded = !_expanded;
                });
              },
            ),
          ),

          // if Expanded
          if( _expanded) Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4
            ),
            height: min(
              widget.order.products.length * 25.0 + 10,
              130
            ),
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
          )
        ],
      ),
    );
  }
}