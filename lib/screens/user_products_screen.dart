import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {

  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {

    // final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName
              );
            },
          )
        ],
      ),
      drawer: AppDrawer(),

      body: FutureBuilder(
        future: Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts( true ),
        builder: ( ctx, snapshot ) => snapshot.connectionState ==ConnectionState.waiting
          ? Center(child: CircularProgressIndicator(),) 
          : RefreshIndicator(
            onRefresh: () {
              return Provider.of<ProductsProvider>(
                  context, listen: false
                )
                .fetchAndSetProducts( true );
            },
            child: Consumer<ProductsProvider>(
              builder: ( _1, productsProvider, _2 ) => Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productsProvider.items.length,
                  itemBuilder: ( _ , index  ) => Column(
                    children: <Widget>[

                      UserProductItem(
                        productsProvider.items[index].id,
                        productsProvider.items[index].title,
                        productsProvider.items[index].imageUrl,
                      ),
                      Divider(
                        thickness: .8,
                        height: 1,
                      )
                    ],
                  )
                ),
              ),
            ),
          ),
      )
      
    );
  }
}