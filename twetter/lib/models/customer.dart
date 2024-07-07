import 'package:hive/hive.dart';

part 'customer.g.dart';

@HiveType(typeId: 0)
class Customer extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? contactNo;

  Customer({
    required this.id,
    required this.name,
    this.contactNo,
  });

  // factory Customer.fromJson(Map<String, dynamic> json) {
  //   return Customer(
  //     id: json['id'] ?? Uuid().v4(),
  //     name: json['name'],
  //     contactNo: json['contactNo'],
  //   );
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'contactNo': contactNo,
  //   };
  // }

  @override
  String toString() {
    return 'Customer{id: $id, name: $name, contactNo: $contactNo}';
  }
}
