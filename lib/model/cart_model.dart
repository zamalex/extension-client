import 'dart:convert';

class CartModel{
  int salon_id;
  int id;
  String name;
  String salon;
  int quantity;
  double price;

  CartModel({this.id,this.name,this.salon,this.quantity,this.price,this.salon_id});

  factory CartModel.fromJson(Map<String, dynamic> jsonData) {
    return CartModel(
      id: jsonData['id'] as int,
      name: jsonData['name'] as String,
      salon: jsonData['salon']as String,
      quantity: jsonData['quantity'] as int,
      price: jsonData['price']as double,

    );
  }
  static Map<String, dynamic> toMap(CartModel item) => {
    'id': item.id,
    'name': item.name,
    'salon': item.salon,
    'quantity': item.quantity,
    'price': item.price,

  };
  static String encode(List<CartModel> musics) => json.encode(
    musics
        .map<Map<String, dynamic>>((music) => CartModel.toMap(music))
        .toList(),
  );

  static List<CartModel> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<CartModel>((item) => CartModel.fromJson(item as Map<String,dynamic>))
          .toList();
}
