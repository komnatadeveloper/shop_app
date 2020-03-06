import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders')
      ),

      body: ListView.builder(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (ctx, index) {
          return 
        },
      ),
    );
  }
}