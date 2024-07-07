// import 'package:flutter/material.dart';
//
// import '../models/order.dart';
//
// class OrderDetailsDialog extends StatelessWidget {
//   final Order order;
//
//   const OrderDetailsDialog({Key? key, required this.order}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Order Details'),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildDetailRow('Customer Name', Text(order.customerName)),
//             _buildDetailRow('Piece', Text(order.piece)),
//             _buildDetailRow(
//               'Sizes and Quantities',
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: order.sizesQuantityMap.entries
//                     .map((entry) =>
//                         Text('Size: ${entry.key}, Quantity: ${entry.value}'))
//                     .toList(),
//               ),
//             ),
//             _buildDetailRow(
//               'Date',
//               Text(order.date.toIso8601String().split('T')[0]),
//             ),
//             _buildDetailRow(
//               'Total Payment',
//               Text('\$${order.totalPayment.toStringAsFixed(2)}'),
//             ),
//             _buildDetailRow(
//               'Payment Done',
//               Text('\$${order.paymentDone.toStringAsFixed(2)}'),
//             ),
//             _buildDetailRow(
//               'Payment Due',
//               Text('\$${order.paymentDue.toStringAsFixed(2)}'),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Close'),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDetailRow(String label, Widget value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(width: 100, child: Text(label)),
//           SizedBox(width: 16),
//           Expanded(child: value),
//         ],
//       ),
//     );
//   }
// }
