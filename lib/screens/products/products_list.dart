import 'package:flutter/material.dart';
import 'package:salon/screens/products/product_item.dart';

class ProductsList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(padding:EdgeInsets.symmetric(horizontal: 10),height: MediaQuery.of(context).size.height,child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return ProdcutItem();
        }
    ) ,color: Colors.white,);
  }
}

