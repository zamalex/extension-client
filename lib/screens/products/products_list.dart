import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon/configs/constants.dart';
import 'package:salon/model/cart_provider.dart';
import 'package:salon/screens/products/product_item.dart';

class ProductsList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Container(padding:EdgeInsets.symmetric(horizontal: 10),height: MediaQuery.of(context).size.height,child: GridView.builder(
      physics: ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: Provider.of<CartProvider>(context).items.length,
        itemBuilder: (BuildContext context, int index) {
          return ProdcutItem(Provider.of<CartProvider>(context).items[index]);
        }
    ) ,color: kScaffold,);
  }
}

