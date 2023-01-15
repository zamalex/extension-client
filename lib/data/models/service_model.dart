
class ServiceModel {
  ServiceModel(
    this.id,
    this.price,
    this.duration,
    this.name,
    this.description,
      {this.base_price,
        this.image,
        this.has_discount,
      }
  );

  ServiceModel.all(
      this.id,
      this.seller_id,
      this.shop_id,
      this.price,
      this.duration,
      this.name,
      this.description,
  {this.base_price,
    this.has_discount,
    this.image
  }
      );


  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      json['id'] as int ?? 0,
      json['price'] as double ?? 0.0,
      json['duration'] as int ?? 0,
      json['name'] as String ?? '',
      json['description'] as String ?? '',

    );
  }

  final int id;
  int shop_id;
  int seller_id;
  bool has_discount;
  final double price;
  final double base_price;
  final int duration;
  final String name;
  final String image;
  final String description;

  @override
  String toString() {
    return name;
  }
}
