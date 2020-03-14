import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_provider.dart' show OrdersProvider;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';


  @override
  Widget build(BuildContext context) {
    
    // final ordersProvider = Provider.of<OrdersProvider>(context);
    // print('Building Orders Screen');

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders')
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:  Provider.of<OrdersProvider>(
          context,
          listen: false
        ).fetchAndSetOrders() ,

        builder: ( ctx, dataSnapShot ) {
          if ( dataSnapShot.connectionState == ConnectionState.waiting ) {
            return Center(child: CircularProgressIndicator(),);
          }

          if( dataSnapShot.error != null ) {
            // Do error handling stuff
            return Center(child: Text('An error occured'),);
          }

          return Consumer<OrdersProvider>(
            builder: ( ctx2, ordersProvider, child ) => ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (ctx2, index) {
                return OrderItem(
                  ordersProvider.orders[index]
                );
              },
            ),
          ); 

        },

      ),


    );
  }
}