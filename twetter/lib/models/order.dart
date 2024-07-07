import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 1)
class Order extends HiveObject {
  @HiveField(0)
  final String piece;

  @HiveField(1)
  final Map<String, int> sizesQuantityMap;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String customerName;

  @HiveField(4)
  final String? customerId;

  @HiveField(5)
  final double totalPayment;

  @HiveField(6)
  final double paymentDone;

  @HiveField(7)
  final double paymentDue;

  Order({
    required this.piece,
    required this.sizesQuantityMap,
    required this.date,
    required this.customerName,
    this.customerId,
    required this.totalPayment,
    required this.paymentDone,
    required this.paymentDue,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      piece: json['piece'],
      sizesQuantityMap: Map<String, int>.from(json['sizesQuantityMap']),
      date: DateTime.parse(json['date']),
      customerName: json['customerName'],
      customerId: json['customerId'],
      totalPayment: json['totalPayment'].toDouble(),
      paymentDone: json['paymentDone'].toDouble(),
      paymentDue: json['paymentDue'].toDouble(),
    );
  }
}
