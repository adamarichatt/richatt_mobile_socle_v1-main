class Customer {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  
  final String? name;
  final String? lange;
  final String? presentation;
  final String? imageUrl;

  Customer({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
 
    this.name,
    this.lange,
    this.presentation,
    this.imageUrl,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lasttName'],
      email: json['email'],
      phone: json['phone'],
      
      name: json['name'],
      lange: json['lange'],
      presentation: json['presentation'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lasttName': lastName,
      'email': email,
      'phone': phone,
      
      'name': name,
      'lange': lange,
      'presentation': presentation,
      'imageUrl': imageUrl,
    };
  }
}
