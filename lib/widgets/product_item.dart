import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {

    // final String id;
    // final String title;
    // final String imageUrl;

    // ProductItem( 
    //   this.id,
    //   this.title,
    //   this.imageUrl
    // );


  @override
  Widget build(BuildContext context) {

    // final product = Provider.of<Product>(context);

    return Consumer<Product>(
      builder: ( ctx, productInstance, child ) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(



          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: productInstance.id
              );
            },
            child: Image.network(
              productInstance.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                productInstance.isFavorite 
                ?
                Icons.favorite
                :
                Icons.favorite_border
              ), 
              onPressed: () {
                productInstance.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
            title: Text(
              productInstance.title,
              textAlign: TextAlign.center,
            ),

            trailing: IconButton(
              icon: Icon(Icons.shopping_cart), 
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
       
    );
  }
}