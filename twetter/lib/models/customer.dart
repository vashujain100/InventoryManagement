import 'package:uuid/uuid.dart';

class Customer {
  String id;
  final String name;
  final String? contactNo;

  Customer({
    required this.id,
    required this.name,
    this.contactNo,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? Uuid().v4(),
      name: json['name'],
      contactNo: json['contactNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactNo': contactNo,
    };
  }

  @override
  String toString() {
    return 'Customer{id: $id, name: $name, contactNo: $contactNo}';
  }
}
