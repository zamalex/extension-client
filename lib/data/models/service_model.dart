class ServiceModel {
  ServiceModel(
    this.id,
    this.price,
    this.duration,
    this.name,
    this.description,
  );

  ServiceModel.all(
      this.id,
      this.seller_id,
      this.shop_id,
      this.price,
      this.duration,
      this.name,
      this.description,
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
  final double price;
  final int duration;
  final String name;
  final String description;

  @override
  String toString() {
    return name;
  }
}
