class Order {
  final String piece;
  final Map<String, int> sizesQuantityMap;
  final DateTime date;
  final String customerName;
  final String? customerId; // Optional customer ID
  final double totalPayment;
  final double paymentDone;
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
