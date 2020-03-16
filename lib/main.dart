import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/auth_provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) 
  {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider()
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider >(
          create: ( ctx ) => ProductsProvider( null, [] ),
          update: (  _,   authProvider, previousProducstProvider   ) => ProductsProvider( 
            authProvider.token ,
            previousProducstProvider == null 
              ? []
              : previousProducstProvider.items
          ),
          
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: OrdersProvider(),
        ),
      ],    

      child: Consumer<AuthProvider>(
        builder: ( ctx, authData, _ ) =>  MaterialApp(
          title: 'MyShop',
          theme: ThemeData( 
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            // This is because of an error 2020.03.12
              

            // primaryTextTheme: TextTheme(
            //   headline6: TextStyle(
            //     color: Colors.orange
            //   )
            // )
            // // This is because of an error 2020.03.12
          ),
          home: authData.isAuth 
            ? ProductsOverviewScreen()        
            : AuthScreen(),   

          routes: {

            ProductsOverviewScreen.routeName : (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName : (ctx) => ProductDetailScreen(),
            CartScreen.routeName : (ctx) => CartScreen(),
            OrdersScreen.routeName : (ctx) => OrdersScreen(),
            UserProductsScreen.routeName : (ctx) => UserProductsScreen(),
            EditProductScreen.routeName : (ctx) => EditProductScreen(),
          },
        ),
      ) 
    );
  }
}