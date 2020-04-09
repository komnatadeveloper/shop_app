import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Providers
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/auth_provider.dart';
// Screens
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
// Others
import './helpers/custom_route.dart';

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

        // Auth Provider
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider >(
          create: ( ctx ) => ProductsProvider( null, null, [] ),
          update: (  _,   authProvider, previousProducstProvider   ) => ProductsProvider( 
            authProvider.token ,
            authProvider.userId,
            previousProducstProvider == null 
              ? []
              : previousProducstProvider.items
          ),          
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),

        // Orders Provider
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider >(
          create: ( ctx ) => OrdersProvider( null, null, [] ),
          update: (  _,   authProvider, previousOrdersProvider   ) => OrdersProvider( 
            authProvider.token ,
            authProvider.userId,
            previousOrdersProvider == null 
              ?  [] 
              : previousOrdersProvider.orders
          ),          
        ),
      ],    

      child: Consumer<AuthProvider>(
        builder: ( ctx, authData, _ ) =>  MaterialApp(
          title: 'MyShop',
          theme: ThemeData( 
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder()
              }
            )
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
            : FutureBuilder(
              future: authData.tryAutoLogin(),
              builder: ( _, authResultSnapShot ) => 
                authResultSnapShot.connectionState == ConnectionState.waiting
                  ? SplashScreen()
                  : AuthScreen(), 
          ),   

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