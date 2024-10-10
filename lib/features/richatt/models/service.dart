class Service {
  final String? id;
  final String name;
  final double? duration;
  final double? price;
  final String? description;

  Service({
    this.id,
    required this.name,
    this.duration,
    this.price,
    this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      duration: json['duration'],
      price: json['price'],
      description: json['description'],
    );
  }
}
