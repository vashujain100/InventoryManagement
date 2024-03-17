import 'package:uuid/uuid.dart';

class Customer {
  final String id;
  final String name;
  final String? contactNo;
  final double totalPaymentPending;

  Customer({
    required this.name,
    this.contactNo,
    required this.totalPaymentPending,
  }) : id = const Uuid().v4();

  @override
  String toString() {
    return 'Customer{id: $id, name: $name, contactNo: $contactNo, totalPaymentPending: $totalPaymentPending}';
  }
}
