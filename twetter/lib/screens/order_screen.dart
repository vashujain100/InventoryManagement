import 'package:flutter/material.dart';

import '../data.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Customer Name')),
            DataColumn(label: Text('Piece')),
            DataColumn(label: Text('Sizes')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Total Payment')),
            DataColumn(label: Text('Payment Done')),
            DataColumn(label: Text('Payment Due')),
          ],
          rows: Data.orders.map((order) {
            return DataRow(cells: [
              DataCell(Text(order.customerName)),
              DataCell(Text(order.piece)),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: order.sizesQuantityMap.entries
                      .map((entry) =>
                          Text('Size: ${entry.key}, Quantity: ${entry.value}'))
                      .toList(),
                ),
              ),
              DataCell(Text(order.date.toString())),
              DataCell(Text('\$${order.totalPayment.toStringAsFixed(2)}')),
              DataCell(Text('\$${order.paymentDone.toStringAsFixed(2)}')),
              DataCell(Text('\$${order.paymentDue.toStringAsFixed(2)}')),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
